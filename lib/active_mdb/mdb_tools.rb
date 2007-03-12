module MDBTools
  include Inflector
  
  DELIMITER = '::'
  LINEBREAK = "\n"
  SANITIZER = /^\w\.\_/ # dumb filter for SQL arguments
  BACKENDS = %w{ access mysql oracle postgres sybase }
  
  def check_file(mdb_file)
    raise ArgumentError, "File not found: #{mdb_file}" unless File.exist?(mdb_file)
    @mdb_version = `mdb-ver #{mdb_file} 2>&1`.chomp
    if $? != 0
      raise ArgumentError, "mdbtools cannot access #{mdb_file}"
    end
    mdb_file
  end
  
  def check_table(mdb_file, table_name)
    unless mdb_tables(mdb_file).include?(table_name)
      raise ArgumentError, "mdbtools does not think a table named \"#{table_name}\" exists"
    end
    table_name
  end
  
  def mdb_tables(mdb_file, options = {})
    included, excluded = options[:include], options[:exclude]
    return `mdb-tables -1 #{mdb_file}`.split(LINEBREAK) if not (included || excluded)
    raise ArgumentError if (options[:include] && options [:exclude])
    if options[:exclude]
      regex = Regexp.new options[:exclude].to_a.join('|') 
      tables = `mdb-tables -1 #{mdb_file}`.split(LINEBREAK).delete_if { |name| name =~ regex }
    end
    if options[:include]
      regex = Regexp.new options[:include].to_a.join('|')
      tables = `mdb-tables -1 #{mdb_file}`.split(LINEBREAK).select { |name| name =~ regex }
    end
    tables
  end
    
  def sql_select(mdb_file, table_name, attributes = nil, conditions ={})
    attributes ||= ['*']
    sql = "select #{attributes.join(' ')} from #{table_name} where #{conditions}".dump
    mdb_sql(mdb_file, sql)
  end
  
  
  def mdb_sql(mdb_file, sql)
    # puts sql
    result = `echo -n #{sql} | mdb-sql -Fp -H -d '#{DELIMITER}' #{mdb_file}`.strip
    arrays = delimited_to_arrays(result)
  end
  
  def compile_conditions(conditions_hash, *args)
    conditions = conditions_hash.sort_by{|k,v| k.to_s}.map do |column_name, value|
      if block_given?
        yield column_name, value
      else
        "#{column_name} like '%#{value}%'"        
      end
    end.join(' AND ')
  end
  
  def mdb_export(mdb_file, table_name, options = {})
    defaults = {  :format => 'sql',
                  :headers => false,
                  :sanitize => true  }
    options = defaults.merge options
    
    args = []
    if options[:delimiter]
      args << "-d #{options[:delimiter].dump}"
    elsif options[:format] == 'sql'
      args << "-I "
    elsif options[:format] == 'csv'
      args << "-d ',' "
    else
      raise ArgumentError, "Unknown format:  #{options[:format]}"
    end
    
    args << "-H " unless options[:headers] == true
    args << "-S" unless options[:sanitize] == false
    `mdb-export #{args} #{mdb_file} #{table_name.to_s.dump}`
  end
  
  def describe_table(mdb_file, table_name)
    command = "describe table \"#{table_name}\"".dump
    description = `echo -n #{command} | mdb-sql -Fp -d '#{DELIMITER}' #{mdb_file}`.strip
    arrays = delimited_to_arrays(description)
    arrays_to_hashes(arrays.shift, arrays)
  end
  
  def mdb_schema(mdb_file, table_name)
    schema = `mdb-schema -T #{table_name.dump} #{mdb_file}`
  end

  
  def table_to_csv(mdb_file, table_name)
    mdb_export(mdb_file, table_name, :format => 'csv', :headers => true)
  end
  
  def delimited_to_arrays(text)
    text.gsub!(/\r\n/,' ')
    text.split(LINEBREAK).collect { |row| row.split(DELIMITER)}
  end
  
  def arrays_to_hashes(headers, arrays)
    arrays.collect do |record|
      record_hash = Hash.new
      until record.empty? do
        headers.each do |header|
          record_hash[header] = record.shift
        end
      end
      record_hash
    end
  end
  

  
  def methodize(table_name)
    underscore table_name
  end
  
  def backends
    BACKENDS
  end
  
  def sanitize!(string)
    string.gsub!(SANITIZER, '')
  end
  
  def mdb_truth(value)
    case value
    when false
      0
    when true
      1
    when 0
      0
    when 1
      1
    when "0"
      0
    when "1"
      1
    end
  end
  
end
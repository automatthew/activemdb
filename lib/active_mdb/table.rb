# require 'mdb_tools'  

# Deprecated.  So very deprecated.
class Table
  include MDBTools
  
  attr_reader :mdb_file, :table_name, :columns, :record_struct, :schema
  attr_accessor :primary_key
  
  
  def initialize(mdb, table_name, prefix)
    @mdb_file = check_file(mdb.mdb_file)
    @table_name = check_table(@mdb_file, table_name)
    # @schema = mdb_schema(@mdb_file, @table_name)
    @columns = describe_table(mdb_file, table_name).map do |column|
      Column.new_from_describe(column)
    end
    @record_struct = create_record_struct
  end
  
  
  def [](method_name)
    self.columns.detect {|c| c.method_name == method_name }
  end
  
  # returns an array of column names
  def column_names
    columns.collect {|x| methodize(x.method_name).to_sym}
  end
  
  def create_record_struct
    attributes = columns.collect {|column| column.method_name.to_sym}
    Struct.new( *attributes)
  end
  
  def to_csv
    table_to_csv(mdb_file, table_name)
  end

  # returns the first record that meets the equality (sometimes LIKE) conditions
  # of the supplied hash.  No comparison operators available at the moment.
  #
  # find_first :superhero_name => 'The Ironist', :powers => 'Wit'
  #
  # mdb-sql doesn't implement LIMIT yet, so this method pulls all results and
  # calls Array#first on them.  Ooky.
  def find_first(conditions_hash)
    rekey_hash(conditions_hash)
    result = sql_search(conditions_hash).first
    create_record(result) 
  end
  
  
  def find_all(conditions_hash={})
    if conditions_hash.empty?
      return sql_select_where(mdb_file, table_name, nil, '1 = 1').collect {|r| create_record(r)}
    end
    rekey_hash(conditions_hash)
    sql_search(conditions_hash).collect {|r| create_record(r) }
  end
  
  private
  
  def create_record(line)
    Record.new(self, line)
  end
  
  def rekey_hash(conditions_hash)
    conditions_hash.each do |key,value|
      column = self[key.to_s]
      if column.boolean?
        key = column.name + '!'
      else
        key = column.name
      end
    end
  end
  
  # the conditions hash keys are column names, the values are search values
  # e.g. sql_search(:first_name => 'Matthew', :last_name => 'King')
  def sql_search(conditions_hash)
    conditions = compile_conditions(conditions_hash) do |method_name,value|
      column = self[method_name.to_s]
      if column.boolean?
        "#{column.name} = #{mdb_truth(value)}"
      else
        "#{column.name} like '%#{value}%'"
      end
    end
    sql_select_where(mdb_file, table_name, nil, conditions)
  end
  
  
end
  

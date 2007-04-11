module ActiveMDB
  # Hi, I am an imitation of ActiveRecord.
  class Base
    
    def initialize(attributes=nil)
      @attributes = attributes unless attributes.nil?
    end
    
    cattr_accessor :pluralize_table_names, :instance_writer => false
    @@pluralize_table_names = true
    
    class << self # Class methods
      attr_accessor :mdb_file
      attr_reader :mdb
      
      # set the path to the MDB file
      def set_mdb_file(file)
        @mdb_file = file
        @mdb = MDB.new(file)
      end
      
      # set the name of the table in the MDB file
      def table_name
        table_name = Inflector.underscore(Inflector.demodulize(self.to_s))
        table_name = Inflector.pluralize(table_name) if pluralize_table_names
        table_name
      end
      
      # borrowed from ActiveRecord
      def set_table_name(value = nil, &block)
        define_attr_method :table_name, value, &block
      end
      alias :table_name= :set_table_name
      
      # Returns an array of column objects for the table associated with this class.
      def columns
        unless @columns
          @columns = @mdb.columns(table_name)
          # @columns.each {|column| column.primary = column.name == primary_key}
        end
        @columns
      end
      
      def column_names
        @mdb.column_names(table_name)
      end
      
      # returns 'id' unless you overwrite this method using set_primary_key
      def primary_key
        'id'
      end

      # specify the field to be used as a primary key for those
      # operations that require one.  At this time, that isn't really
      # anything except count.
      def set_primary_key(value = nil, &block)
        define_attr_method :primary_key, value, &block
      end
      alias :primary_key= :set_primary_key
    
      def table_exists?
        @mdb.tables.include? table_name
      end
      
      # How many?  Requires that the primary_key return a valid field.
      def count
        @mdb.count(table_name, primary_key)
      end
      
      # the conditions hash keys are column names, the values are search values
      # find_first :superhero_name => 'The Ironist', :powers => 'Wit'
      #
      # mdb-sql doesn't implement LIMIT yet, so this method pulls all results and
      # calls Array#first on them.  Ooky.
      def find_first(conditions_hash)
        # rekey_hash(conditions_hash)
        find_from_hash(conditions_hash).first 
      end
      
      # the conditions hash keys are column names, the values are search values
      # find_all :superhero_name => 'The Ironist', :powers => 'Wit'
      #
      # mdb-sql doesn't implement LIMIT yet, so this method pulls all results and
      # calls Array#first on them.  Ooky.
      def find_all(conditions_hash)
        find_from_hash(conditions_hash)
      end
          
      # borrowed from ActiveRecord.
      def define_attr_method(name, value=nil, &block)
        sing = class << self; self; end
        sing.send :alias_method, "original_#{name}", name
        if block_given?
          sing.send :define_method, name, &block
        else
          # use eval instead of a block to work around a memory leak in dev
          # mode in fcgi
          sing.class_eval "def #{name}; #{value.to_s.inspect}; end"
        end
      end
      
      # relies on stuff that doesn't work right now
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
          
      # supply a conditions string that would nestle gently in a 
      # WHERE clause, after the WHERE but before the.
      def find_where(conditions)
        MDBTools.sql_select_where(mdb_file, table_name, nil, conditions).collect! { |record| instantiate(record) }
      end
      
      # takes a hash where the keys are column names (string or symbol)
      # and the values are the associated values.
      def find_from_hash(hash)
        conditions = conditions_from_hash(hash)
        find_where(conditions)
      end
      
      # the conditions hash keys are column names, the values are search values
      # e.g. search_with_hash(:first_name => 'Matthew', :last_name => 'King')
      def conditions_from_hash(hash)
        MDBTools.compile_conditions(hash) do |column_name, value|
          column = column_for_method(column_name) || column_for_field(column_name)
          raise ArgumentError, "No column corresponding to #{column_name}" unless column
          case column.klass.to_s
          when 'Fixnum', 'Float'
            "#{column.name} = #{value}"
          when 'String'
            "#{column.name} LIKE '%#{value}%'"
          when 'Object'
            value = value ? 1 : 0
            "#{column.name} IS #{value}"
          end
        end
      end
      
      # given the name of a column, return the Column object
      def column_for_field(column_name)
        columns.detect {|c| c.name == column_name.to_s}
      end
      
      def column_for_method(method_name)
        columns.detect {|c| c.method_name == method_name.to_s}
      end
      
      private
      
      def instantiate(record)
        new_hash = {}
        record.each do |name,value|
          # begin
            new_hash[MDBTools.methodize(name)] = column_for_field(name).type_cast(value)
          # rescue
          #   raise "No column for #{name}"
          # end
        end
        self.new new_hash
      end
      
      
    end
    
    private
    
    def method_missing(method_id, *args, &block)
       method_name = MDBTools.methodize(method_id.to_s)
       if @attributes.include?(method_name)
         value = @attributes[method_name]
       else
         super
       end
     end
    
  end
end
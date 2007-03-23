module ActiveMDB
  class Base
    
    def initialize(attributes=nil)
      @attributes = attributes unless attributes.nil?
    end

    
    
    cattr_accessor :pluralize_table_names, :instance_writer => false
    @@pluralize_table_names = true
    
    class << self # Class methods
      attr_accessor :mdb_file
      attr_reader :mdb
      
      def set_mdb_file(file)
        @mdb_file = file
        @mdb = MDB.new(file)
      end
    
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
      
      
      def column_names
        @mdb.column_names(table_name)
      end
      
      def primary_key
        'id'
      end

      def set_primary_key(value = nil, &block)
        define_attr_method :primary_key, value, &block
      end
      alias :primary_key= :set_primary_key
    
      def table_exists?
        @mdb.tables.include? table_name
      end
      
      def count
        @mdb.count(table_name, primary_key)
      end
      
      def find_first(conditions_hash)
        # rekey_hash(conditions_hash)
        sql_search(conditions_hash).first 
      end
      
      def find_all(conditions_hash)
        sql_search(conditions_hash)
      end
          
      # borrowed from ActiveRecord
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
      
      # the conditions hash keys are column names, the values are search values
      # e.g. sql_search(:first_name => 'Matthew', :last_name => 'King')
      def sql_search(conditions_hash)
        conditions = MDBTools.compile_conditions(conditions_hash)
        MDBTools.sql_select(mdb_file, table_name, nil, conditions).collect! { |record| instantiate(record) }
      end
      
      private
      
      def instantiate(record)
        new(record)
      end
      
      
    end
    
    private
    
    def method_missing(method_id, *args, &block)
       method_name = method_id.to_s
       if @attributes.include?(method_name)
         value = @attributes[method_name]
       else
         super
       end
     end
    
  end
end
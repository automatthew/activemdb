module ActiveMDB
  class Base
    
    cattr_accessor :pluralize_table_names, :instance_writer => false
    @@pluralize_table_names = true
    
    class << self # Class methods
      attr_accessor :mdb_file
      attr_reader :mdb
    
      def set_mdb_file(file)
        @mdb_file = file
        @mdb = MDB.new(file)
      end
      
      # borrowed from ActiveRecord
      def set_table_name(value = nil, &block)
        define_attr_method :table_name, value, &block
      end
      alias :table_name= :set_table_name
    
      def table_exists?
        @mdb.tables.include? table_name
      end
    
      def table_name
        table_name = Inflector.underscore(Inflector.demodulize(self.to_s))
        table_name = Inflector.pluralize(table_name) if pluralize_table_names
        table_name
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
      
      
    end
    
  end
end
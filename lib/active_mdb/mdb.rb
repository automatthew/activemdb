# require 'mdb_tools'
  
class MDB
  include MDBTools
  
  attr_reader :mdb_file, :prefix, :exclude, :tables
  
  def initialize(mdb_file, options = {})
    @mdb_file = check_file(mdb_file)
    @prefix = options[:prefix] || ''
    @exclude, @include = options[:exclude], options[:include]
    @export_syntax = options[:sql_syntax] || 'mysql'
    @tables = mdb_tables(@mdb_file, :exclude => @exclude, :include => @include)
    # @tables = create_table_objects
  end
  
  def count(table_name, attribute)
    MDBTools.faked_count(@mdb_file, table_name, attribute)
  end
  
  def column_names(table_name)
    MDBTools.fields_for(@mdb_file, table_name)
  end

  
  private

  # Deprecated.
  def create_table_objects
    tables = {}
    @table_names.each do |table|
      tables[table] = Table.new(self, table, @prefix)
      metaclass = class << self; self; end
      metaclass.send :define_method, methodize(table) do
        tables[table]
      end
    end
    tables
  end
  
  
end
  

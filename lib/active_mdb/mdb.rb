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
  
  # consumer of poor, weak MDBTools.faked_count
  def count(table_name, attribute)
    MDBTools.faked_count(@mdb_file, table_name, attribute)
  end
  
  def columns(table_name)
    MDBTools.describe_table(@mdb_file, table_name).map do |column|
      Column.new_from_describe(column)
    end
  end
  
  def column_names(table_name)
    MDBTools.field_names_for(@mdb_file, table_name)
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
  

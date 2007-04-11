# require 'mdb_tools'

# Deprecated way more than Table
class Record
  include MDBTools
  include Enumerable
  
  def initialize(mdb_table, line)
    raise 'no results' unless line
    @struct = mdb_table.record_struct
    @data = @struct.new(*line)
    create_accessors
  end
  
  def each(&block)
    @data.members.each {|k| yield k, @data[k] }
  end
  
  def compact
    self.select {|k,v| v && !v.empty? && v != "0" }
  end
  
  private
  
  def create_accessors
    meta = class << self; self; end
    @struct.members.each do |att|
      meta.send :define_method, att do
        @data[att]
      end
    end
  end
  
end
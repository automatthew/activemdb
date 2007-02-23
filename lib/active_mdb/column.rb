class Column
  include MDBTools
  
  attr_reader :method_name, :name, :type, :size
  
  def initialize(name, type, size)
    @name = name
    @method_name, @type, @size = methodize(name), methodize(type), size.to_i
  end
  
  def self.new_from_describe(describe_hash)
    self.new(describe_hash["Column Name"], describe_hash["Type"], describe_hash["Size"])
  end

  
  def boolean?
    self.type == 'boolean'
  end
  
  
end
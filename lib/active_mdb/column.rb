class Column
  include MDBTools
  
  attr_reader :method_name, :name, :type, :size
  
  def initialize(name, type, size)
    @name, @type = name, type
    @method_name, @size = methodize(name), size.to_i
  end
  
  def self.new_from_describe(describe_hash)
    self.new(describe_hash["Column Name"], describe_hash["Type"], describe_hash["Size"])
  end

  # return Ruby class corresponding to data type.  
  # Borrowed from ActiveRecord
  def klass
    case type
      when 'Text', 'Character'  then String
      when 'Long Integer'       then Fixnum
      when 'Double'             then Float
      when 'Currency', 'Float'  then Float
      when 'DateTime (Short)'   then Time
      when 'Boolean'            then Object
      when 'Decimal'            then BigDecimal
      when 'Binary'             then String
    end
  end
  
  # Casts value (which is a String) to an appropriate instance.
  # Totally borrowed from ActiveRecord
  def type_cast(value)
    return nil if value.nil?
    case type
      when 'Text', 'Character'  then value
      when 'Long Integer'       then value.to_i rescue value ? 1 : 0
      when 'Currency', 'Float'  then value.to_f
      when 'Double'             then value.to_f
      when 'DateTime (Short)'   then self.class.string_to_time(value)
      when 'Boolean'            then self.class.value_to_boolean(value)
      when 'Decimal'            then self.class.value_to_decimal(value)
      when 'Binary'             then self.class.binary_to_string(value)
      else value
    end
  end
  
  def self.value_to_boolean(value)
    if value == true || value == false
      value
    else
      %w(true t 1).include?(value.to_s.downcase)
    end
  end
  
  def boolean?
    self.type == 'boolean'
  end
  
  
end
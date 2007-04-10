require File.join(File.dirname(__FILE__), "..", 'lib', 'active_mdb')
require 'test/unit'
require File.join(File.dirname(__FILE__), 'test_helper')

class ColumnTest < Test::Unit::TestCase
  

  
  def setup
    @c1 = Column.new('is_available', 'Boolean', 0)
  end
  
  def test_boolean_column
    assert_equal false, @c1.type_cast(0)
  end
  

  
end
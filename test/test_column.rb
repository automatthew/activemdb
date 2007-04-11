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
  
  def test_string_to_time
    time = '05/18/76 00:00:00'
    assert_equal 1976, Column.string_to_time(time).year
    assert_equal 5, Column.string_to_time(time).month
  end
  
end
require File.join(File.dirname(__FILE__), "..", 'lib', 'active_mdb')
require 'test/unit'
require File.join(File.dirname(__FILE__), 'test_helper')

class MDBTest < Test::Unit::TestCase

  def setup
    
  end
  
  def test_table_exclusion
    create_mdb(:exclude => ['Inventory'])
    assert !@db.tables.include?('Inventory')
  end
  
  def test_table_inclusion
    create_mdb(:include => ['Inventory', 'Room'])
    assert_equal ['Inventory', 'Room'], @db.tables.sort
  end
  

  
  

  
  
end
  
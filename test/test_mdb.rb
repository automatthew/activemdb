require File.join(File.dirname(__FILE__), "..", 'lib', 'active_mdb')
require 'test/unit'
require File.join(File.dirname(__FILE__), 'test_helper')

class MDBTest < Test::Unit::TestCase
  


  def setup
    
  end
  
  def test_table_exclusion
    create_mdb(:exclude => ['Inventory'])
    assert !@db.table_names.include?('Inventory')
  end
  
  def test_table_inclusion
    create_mdb(:include => ['Inventory', 'Room'])
    assert_equal ['Inventory', 'Room'], @db.table_names.sort
  end
  
  def test_reflection
    create_mdb
    assert_respond_to @db, 'computer'
    assert_respond_to @db, 'employee'
    assert_respond_to @db, 'room'
  end
  
  

  
  
end
  
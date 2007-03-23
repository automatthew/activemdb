require File.join(File.dirname(__FILE__), "..", 'lib', 'active_mdb')
require 'test/unit'
require File.join(File.dirname(__FILE__), 'test_helper')

class BaseTest < Test::Unit::TestCase
  
  class NonExistentTable < ActiveMDB::Base
    set_mdb_file TEST_DB
  end
  class Employee < ActiveMDB::Base
    set_mdb_file TEST_DB
  end
  class Room < ActiveMDB::Base
    set_mdb_file TEST_DB
    set_table_name 'Room'
  end
  

  
  def test_setting_mdb_file
    assert_equal TEST_DB, Employee.mdb_file
  end
  
  
  def test_mdb_creation
    mdb = Employee.mdb
    assert_not_nil mdb
    assert_respond_to mdb, :tables
  end
  
  def test_get_table_name
    assert_equal 'employees', Employee.table_name
    ActiveMDB::Base.pluralize_table_names = false
    assert_equal 'employee', Employee.table_name
  end
  
  def test_set_table_name
    Employee.set_table_name('foo')
    assert_equal 'foo', Employee.table_name
    assert_equal 'Room', Room.table_name
  end
  
  def test_table_exists
    assert !NonExistentTable.table_exists?
    assert Room.table_exists?
  end
  

end
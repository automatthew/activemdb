require File.join(File.dirname(__FILE__), "..", 'lib', 'active_mdb')
require 'test/unit'
require File.join(File.dirname(__FILE__), 'test_helper')

class BaseTest < Test::Unit::TestCase
  
  class NonExistentTable < ActiveMDB::Base
    set_mdb_file TEST_DB
  end
  class Employee < ActiveMDB::Base
    set_mdb_file TEST_DB
    set_table_name 'Employee'
    set_primary_key 'Emp_Id'
  end
  class Room < ActiveMDB::Base
    set_mdb_file TEST_DB
    set_table_name 'Room'
    set_primary_key 'Room'
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
    assert_equal 'non_existent_tables', NonExistentTable.table_name
    ActiveMDB::Base.pluralize_table_names = false
    assert_equal 'non_existent_table', NonExistentTable.table_name
  end
  
  def test_set_table_name
    Employee.set_table_name('foo')
    assert_equal 'foo', Employee.table_name
    assert_equal 'Room', Room.table_name
    Employee.set_table_name('Employee')
  end
  
  def test_table_exists
    assert !NonExistentTable.table_exists?
    assert Room.table_exists?
  end
  
  def test_get_and_set_primary_key
    assert_equal 'Emp_Id', Employee.primary_key
    Employee.set_primary_key 'employee_id'
    assert_equal 'employee_id', Employee.primary_key
  end
  
  def test_count
    assert_equal 92, Room.count
    assert_equal 53, Employee.count
  end
  
  def test_instantiate
    hash = [{"Department"=>"Engineering", "Gender"=>"M", "Room"=>"6072", "Title"=>"Programmer", "Emp_Id"=>"1045", "First_Name"=>"Robert", "Last_Name"=>"Weinfeld"}]
    record = Employee.send(:instantiate, hash)
    assert_equal hash, record.instance_variable_get('@attributes')
  end
  
  def test_sql_search
    record = Employee.sql_search(:Room => '6072').first
    assert_kind_of Employee, record
  end
  
  def test_attribute_magic
    record = Employee.sql_search(:Room => '6072').first
    assert_equal '6072', record.Room
  end
  
  
  def test_find_all
    assert_equal 2, Employee.find_all(:First_Name => 'G').size
  end
  

  

end
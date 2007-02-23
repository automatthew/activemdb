require File.join(File.dirname(__FILE__), "..", 'lib', 'active_mdb')
require 'test/unit'
require File.join(File.dirname(__FILE__), 'test_helper')


class MDBToolsTest < Test::Unit::TestCase
  include MDBTools
  
  EXCLUDE = ['Inventory']
  TEST_TABLES = %w{ Room Computer Employee  }
  TORBATI_Y = {"Department"=>"Engineering",
   "Gender"=>"F",
   "Room"=>"6044",
   "Title"=>"Programmer",
   "Emp_Id"=>"1000",
   "First_Name"=>"Yolanda",
   "Last_Name"=>"Torbati"}
  README = File.join(File.dirname(__FILE__), "..", "README")
  
  def setup
    @employees_csv = mdb_export(TEST_DB, 'Employee', :format => 'csv', :headers => true)
  end
  
  def test_check_file
    assert_nothing_raised { check_file TEST_DB }
    assert_raise(ArgumentError) { check_file 'completely_bogus_filename' }
    # the README file is obviously not an Access database
    assert_raise(ArgumentError) { check_file README}
  end
  
  def test_check_table
    assert_nothing_raised { check_table TEST_DB, 'Employee'}
    assert_raises(ArgumentError) { check_table TEST_DB, 'foobarbaz' }
  end
  
  def test_mdb_tables
    tables1 = mdb_tables(TEST_DB, :exclude => EXCLUDE)
    assert_equal TEST_TABLES, tables1

    assert_raises( ArgumentError) { mdb_tables(TEST_DB, :include => [], :exclude => []) }
    tables4 = mdb_tables(TEST_DB, :exclude => 'Room')
    assert_equal %w{Computer Employee Inventory}, tables4
  end
  
  def test_mdb_tables_with_include
    tables = mdb_tables(TEST_DB, :include => ['Room', 'Computer'])
    assert_equal ['Room', 'Computer'], tables
  end
  
  def test_mdb_tables_with_nils
    assert_nothing_raised do
      tables = mdb_tables(TEST_DB, :include => nil, :exclude => nil)
      assert_not_nil tables
    end
  end
  
  def test_mdb_schema
    assert_nothing_raised { @schema = mdb_schema(TEST_DB, 'Employee') }
    assert_match /DROP TABLE/, @schema
  end
  
  
  # def test_csv_to_hashes
  #   employee_hash = csv_to_hashes(@employees_csv)
  #   assert_equal TORBATI_Y, employee_hash.first
  # end
  
  def test_sql_select
    assert_equal ["Torbati","Yolanda", "F", "Programmer", "Engineering", "6044", "1000"], 
        sql_select(TEST_DB, 'Employee', ['*'], "First_Name LIKE 'Yolanda'" ).first
  end
  
  def test_compile_conditions
    conditions = {:foo => 'bar', :baz => 1, :nark => 'noo'}
    assert_equal "baz like '%1%' AND foo like '%bar%' AND nark like '%noo%'", compile_conditions(conditions)
  end
  
  def test_compiled_sql_select
    sql_select(TEST_DB, 'Employee', nil, compile_conditions(:first_name => 'Yolanda'))
  end
  
  def test_export_table_to_sql
    # this test is dependent on specific content in the sample database
    export = mdb_export(TEST_DB, 'Computer', :format => 'sql').split(LINEBREAK)
    assert_equal 172, export.size
    assert export.first =~ /INSERT INTO.*MITSUBISHI.*HL6605ATK/
  end
  
  def test_export_table_to_csv
    export = mdb_export(TEST_DB, 'Employee', :format => 'csv').split(LINEBREAK)
    assert_equal 53, export.size
    assert export.first =~ /\"Torbati\",/
  end
  
  def test_backends
    assert_nothing_raised { backends }
  end
  
  
end
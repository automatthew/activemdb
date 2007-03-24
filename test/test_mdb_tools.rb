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
  
  def test_valid_file
    assert valid_file?(TEST_DB)
    assert !valid_file?(NOT_A_DB)
  end
  
  def test_mdb_version
    assert_equal 'JET3', mdb_version(TEST_DB)
    assert_equal '', mdb_version(NOT_A_DB)
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
  
  def test_describe_table
    descriptions = describe_table(TEST_DB, 'Employee')
    assert_kind_of Array, descriptions
    assert_kind_of Hash, descriptions.first
    assert_equal 3, descriptions.first.size
    assert_not_nil descriptions.first['Type']
  end
  
  def test_mdb_sql
    result = [{"Department"=>"Human Resources", "Gender"=>"F", "Room"=>"6150", "Title"=>"Vice President", "Emp_Id"=>"1025", "First_Name"=>"Kathy", "Last_Name"=>"Ragerie"}]
    assert_equal result, mdb_sql(TEST_DB, "select * from Employee where Room = '6150'")
    bees =  mdb_sql(TEST_DB, "select * from Employee where Last_Name like 'B%'")
    assert_kind_of Array, bees
    b = bees.first
    assert_kind_of Hash, b
  end
  
  def test_field_names_for
    fields = ["First_Name", "Gender", "Title", "Department", "Room", "Emp_Id"]
    assert_equal fields, field_names_for(TEST_DB, 'Employee')
  end

  
  # def test_csv_to_hashes
  #   employee_hash = csv_to_hashes(@employees_csv)
  #   assert_equal TORBATI_Y, employee_hash.first
  # end
  
  def test_sql_select
    yo = {"Department"=>"Engineering", "Gender"=>"F", "Room"=>"6044", "Title"=>"Programmer", "Emp_Id"=>"1000", "First_Name"=>"Yolanda", "Last_Name"=>"Torbati"}
    assert_equal yo, sql_select(TEST_DB, 'Employee', ['*'], "First_Name LIKE 'Yolanda'" ).first
  end
  
  def test_compile_conditions
    conditions = {:foo => 'bar', :baz => 1, :nark => 'noo'}
    assert_equal "baz like '%1%' AND foo like '%bar%' AND nark like '%noo%'", compile_conditions(conditions)
  end
  
  def test_compiled_sql_select
    sql_select(TEST_DB, 'Employee', nil, compile_conditions(:first_name => 'Yolanda'))
  end
  
  def test_count
    assert_equal 92, faked_count(TEST_DB, 'Room', 'Room', nil)
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
# require File.join(File.dirname(__FILE__), "..", 'lib', 'active_mdb')
# require 'test/unit'
# require File.join(File.dirname(__FILE__), 'test_helper')
# 
# class TableTest < Test::Unit::TestCase
#   
#   
#   def setup
#     create_mdb
#     @employee = @db.employee
#   end
#   
#   def test_columns
#     columns = @employee.columns
#     assert_kind_of Array, columns
#     assert_kind_of Column, columns.first
#     assert_equal 7, columns.size
#   end
#   
#   def test_create_record_struct
#     assert_kind_of Class, @employee.record_struct
#     members = @employee.record_struct.members
#     assert_equal 7, members.size
#     assert members.include?('emp_id')
#   end
#   
#   def test_to_csv
#     csv_text = @employee.to_csv
#     assert_kind_of String, csv_text
#     arrays = csv_text.split(MDBTools::LINEBREAK)
#     
#     # grab the headers and test for content
#     assert arrays.shift.include?('Emp_Id')
#     assert_equal 53, arrays.size
#   end
#   
#   def test_find_first
#     y = @employee.find_first(:first_name => 'Yolanda')
#     assert_kind_of Record, y
#     assert_equal 'Yolanda', y.first_name
#   end
#   
#   def test_find_all
#     a_names = @employee.find_all(:last_name => 'A')
#     assert_kind_of Array, a_names
#     assert_kind_of Record, a_names.first
#     assert_equal 2, a_names.size
#   end
#   
# end

# require File.join(File.dirname(__FILE__), "..", 'lib', 'active_mdb')
# require 'test/unit'
# require File.join(File.dirname(__FILE__), 'test_helper')
# 
# class RecordTest < Test::Unit::TestCase
# 
#   def setup
#     create_mdb
#     @employee = @db.employee
#     @line = ["Torbati","Yolanda", "F", "Programmer", "Engineering", "6044", "1000"]
#     assert_nothing_raised { @record = Record.new(@employee, @line) }
#   end
#   
#   def test_reflection
#     assert_respond_to @record, 'gender'
#     assert_respond_to @record, 'emp_id'
#     assert_equal 'Yolanda', @record.first_name
#   end
#   
#   def test_display
#     
#   end
# 
# end
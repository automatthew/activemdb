require 'test/unit'

class Test::Unit::TestCase
  
  TEST_DB =  File.join(File.dirname(__FILE__), '..', 'db', 'sample.mdb')

  
  protected
  
  def create_mdb(options={})
    excluded = options[:exclude]
    included = options[:include]
    assert_nothing_raised { @db = MDB.new(TEST_DB, :exclude => excluded, :include => included ) }
  end
  
end
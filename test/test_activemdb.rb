require File.join(File.dirname(__FILE__), "..", 'lib', 'active_mdb')
require 'test/unit'
require File.join(File.dirname(__FILE__), 'test_helper')

class RealWorldTest < Test::Unit::TestCase
  
  RETREAT = '../db/retreat.mdb'
  
  class Family < ActiveMDB::Base
    set_mdb_file RETREAT
    set_table_name 'tblFamilyData'
  end
  
  class Cabin < ActiveMDB::Base
    set_mdb_file 'db/retreat.mdb'
    set_table_name 'tCabins'
  end
  
  def setup
    @retreat = MDB.new(RETREAT)
  end
  
  def test_tables
    tables = ["JobAssignmentsByCabin","Switchboard Items","tblAdultChildCode","tblCities","tblFamilyData","tblGender","tblIndividData","tblStatusChurch","tblStatusIndiv","tCabinAssignments","tCabins","tCampRates","tCampScholarships","tJobs","tJobsR","tParkAreas","tPayments","tRetreatEnrollment","tSponsors","tblStatusFamily"]
    assert_equal tables, @retreat.tables
  end

  def test_columns
    column_names = ["LName", "HisName", "HerName", "HmAddress", "AddressNumber", "StreetDirection", "StreetName", "HmAddress2", "City", "State", "Zip", "HmPhone", "UnLstHmPho?"]
    assert_equal column_names, Family.column_names
  end

end
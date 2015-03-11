$:.unshift(File.dirname(__FILE__))
module ActiveMDB
  VERSION = '0.2.3'
end


require 'rubygems'
require 'active_support/core_ext'
require 'active_mdb/mdb_tools'
load 'active_mdb/mdb.rb'
load 'active_mdb/table.rb'
load 'active_mdb/record.rb'
load 'active_mdb/column.rb'
load 'active_mdb/base.rb'





# -*- ruby -*-

require 'rubygems'
require './lib/active_mdb.rb'

begin
  gem 'echoe', '>=2.7'
  require 'echoe'
  Echoe.new('activemdb', ActiveMDB::VERSION) do |p|
    p.project = 'activemdb'
    p.summary = 'ActiveRecordy wrapper around MDB Tools, allowing POSIX platforms to read MS Access (.mdb) files'
    p.author = "Matthew King"
    p.email = "automatthew@gmail.com"
    p.url = 'http://activemdb.rubyforge.org/'
    p.ignore_pattern = /^(\.git).+/
    p.test_pattern = "test/test_*.rb"
    p.runtime_dependencies = ["fastercsv >=1.2.3"]
  end
rescue
  "(ignored echoe gemification, as you don't have the Right Stuff)"
end

# vim: syntax=Ruby

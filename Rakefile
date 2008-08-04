# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/active_mdb.rb'

Hoe.new('activemdb', ActiveMDB::VERSION) do |p|
  p.rubyforge_name = 'activemdb'
  p.author = 'Matthew King'
  p.email = 'automatthew@gmail.com'
  p.summary = 'ActiveRecordy wrapper around MDB Tools, allowing POSIX platforms to read MS Access (.mdb) files'
  p.description = p.paragraphs_of('README.txt', 2).join("\n\n")
  p.url = 'http://activemdb.rubyforge.org/'
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.extra_deps = [['fastercsv', '>=1.2.3']]
end

# vim: syntax=Ruby

# encoding: utf-8
require File.expand_path("../lib/active_mdb", __FILE__)

Gem::Specification.new do |gem|
  gem.name = "activemdb"
  gem.version = ActiveMDB::VERSION.dup
  gem.date = "2008-08-04"

  gem.summary = %q{ActiveRecordy wrapper around MDB Tools, allowing POSIX platforms to read MS Access (.mdb) files}
  gem.description = %q{ActiveRecordy wrapper around MDB Tools, allowing POSIX platforms to read MS Access (.mdb) files}

  gem.authors = ["Matthew King"]
  gem.email = ["automatthew@gmail.com"]
  gem.homepage = "http://activemdb.rubyforge.org/"

  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- test/*`.split("\n")
  gem.platform = Gem::Platform::RUBY
  gem.require_paths = ["lib"]
  gem.required_rubygems_version = Gem::Requirement.new(">= 1.8.15")

  gem.add_dependency("activesupport", "= 3.2.19")
  gem.add_dependency("fastercsv", ">= 1.2.3")

  gem.add_development_dependency("rake")
  gem.add_development_dependency("echoe")
end

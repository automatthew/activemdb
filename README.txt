ActiveMDB
by Matthew King
http://rubyforge.org/projects/activemdb/

== DESCRIPTION:
  
Library for getting info out of MS Access (.mdb) files, which uses ActiveRecord-ish reflection to parse table and column names. 

Intended for exploration and migration, not production. And it's *READ ONLY*, confound it to hell. ActiveMDB provides a thin wrapper around the mdb-tables, mdb-schema, mdb-sql, and mdb-export binaries from Brian Bruns's MDB Tools project (http://mdbtools.sourceforge.net/).

== FEATURES/PROBLEMS:
  
* MDBTools - Straightforward wrapper around the CLI tools that you get with libmdb
* ActiveMDB::Base - Subclass to make your models, just like the big shots do.


== SYNOPSIS:

  # When your Access database schema conforms to the 37s stylebook:
  class Bacon < ActiveMDB::Base
    set_mdb_file 'db/wherefore.mdb'
  end

  # in the find_* methods, the entries in the hash 
  # get turned into "WHERE #{key} like %#{value}%" conditions,
  # which fails when the column is a boolean, which is a regression from 0.1.0.
  # I could fix this tonight, but my son is yelling at me to come out for dinner.
  best_bacon = Bacon.find_all(:rind => 'creamy', :sodium_content => 'Awesome!' )
  
  # When it doesn't:
  class Employee < ActiveMDB::Base
    set_mdb_file 'db/sample.mdb'
    set_table_name 'Employee'
    set_primary_key 'Emp_Id'
  end

  paula = Employee.find_first(:Department => 'Engineering', :Specialty => 'paulaBeans')


== REQUIREMENTS:

* http://mdbtools.sourceforge.net/

== INSTALL:

* Sadly, no easy install at this time.  

== LICENSE:

(The MIT License)

Copyright (c) 2007 

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

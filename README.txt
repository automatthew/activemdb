ActiveMDB
by Matthew King
http://rubyforge.org/projects/activemdb/

== DESCRIPTION:
  
Lib for getting info out of MS Access (.mdb) files, which uses ActiveRecord-ish reflection to parse table and column names. 

Intended for exploration and migration, not production. ActiveMDB provides a thin wrapper around the mdb-tables, mdb-schema, mdb-sql, and mdb-export binaries from Brian Bruns's MDB Tools project (http://mdbtools.sourceforge.net/).

== FEATURES/PROBLEMS:
  
* MDB, Table, and Record classes do reflection to provide easy attribute readers
* I really need to refactor the above classes to something more like ActiveRecord::Base, so that you can subclass to make models.

== SYNOPSIS:

  @mdb = MDB.new('db/sample.mdb', :exclude => 'lookups')
  @employees = @mdb.employees

  # in the find_* methods, the entries in the hash 
  # get turned into "WHERE #{key} like %#{value}%" conditions,
  # unless the column is a boolean, in which case the WHERE uses "="
  @employees.find_first :f_name => 'Matthew', :l_name => 'King'

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

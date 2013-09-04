mtar
====

Test of ActiveRecord connections in a multithreaded case

On my computer, running jruby-1.7.2

Happy case:
```bash
mtarcon $ env wait=1 close=1 threads=300 bundle exec ruby run.rb

Testing with 300 threads using `connection.close`. 1 connections in the pool, 1 second wait time.
............................................................................................................................................................................................................................................................................................................

Elapsed real time: 2.026 seconds
```

Failing case
```bash
mtarcon $ env wait=1 close=0 threads=5 bundle exec ruby run.rb

Testing with 5 threads not using `connection.close`. 1 connections in the pool, 1 second wait time.
.DEPRECATION WARNING: Database connections will not be closed automatically, please close your
database connection at the end of the thread by calling `close` on your
connection.  For example: ActiveRecord::Base.connection.close
. (called from mon_synchronize at /Users/graemerouse/.rvm/rubies/jruby-1.7.2/lib/ruby/1.9/monitor.rb:211)
Exception in thread thread 0: ActiveRecord::ConnectionTimeoutError
.Exception in thread thread 3: ActiveRecord::ConnectionTimeoutError
Exception in thread thread 4: ActiveRecord::ConnectionTimeoutError


Elapsed real time: 1.573 seconds
```

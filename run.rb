# Adapted from slide 5 at http://www.slideshare.net/igrigorik/no-callbacks-no-threads-railsconf-2010

require 'rubygems'
require 'active_record'
require 'bundler/setup'
require "awesome_print"

class User < ActiveRecord::Base; end

POOL = (ENV['pool'] || 1).to_i
WAIT = (ENV['waid'] || 1).to_i
THREADS = (ENV['threads'] || 10).to_i
CLOSE = (ENV['close'] || 0).to_i > 0

puts "\nTesting with #{THREADS} threads #{"not " if !CLOSE}using `connection.close`. #{POOL} connections in the pool, #{WAIT} second wait time.\n"

conn = ActiveRecord::Base.establish_connection({
  :adapter => 'mysql',
  :database => 'grpn_ubergateway',
  :pool => POOL,
  :wait_timeout => WAIT,
})

$stdout.sync = true

stime = Time.now

threads = []
THREADS.times do |n|
  threads << Thread.new do
    Thread.current[:name] = "thread #{n}"
    count = User.count
    print '.'
    ActiveRecord::Base.connection.close if CLOSE
    # ActiveRecord::Base.connection_pool.with_connection do |conn|
    #   res = conn.execute("SELECT SLEEP(1)")
    # end
  end
end

threads.each do |t|
  begin
    t.join
  rescue Exception => e
    puts "Exception in thread #{t[:name]}: #{e.class}"
  end
end

puts "\n\nElapsed real time: #{Time.now - stime} seconds"
 
# On my computer, running jruby
# 
# mtarcon $ env wait=1 close=1 threads=300 bundle exec ruby run.rb
# 
# Testing with 300 threads using `connection.close`. 1 connections in the pool, 1 second wait time.
# ............................................................................................................................................................................................................................................................................................................
# 
# Elapsed real time: 2.026 seconds
# mtarcon $ env wait=1 close=0 threads=5 bundle exec ruby run.rb
# 
# Testing with 5 threads not using `connection.close`. 1 connections in the pool, 1 second wait time.
# .DEPRECATION WARNING: Database connections will not be closed automatically, please close your
# database connection at the end of the thread by calling `close` on your
# connection.  For example: ActiveRecord::Base.connection.close
# . (called from mon_synchronize at /Users/graemerouse/.rvm/rubies/jruby-1.7.2/lib/ruby/1.9/monitor.rb:211)
# Exception in thread thread 0: ActiveRecord::ConnectionTimeoutError
# .Exception in thread thread 3: ActiveRecord::ConnectionTimeoutError
# Exception in thread thread 4: ActiveRecord::ConnectionTimeoutError
# 
# 
# Elapsed real time: 1.573 seconds

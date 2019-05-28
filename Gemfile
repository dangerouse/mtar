source 'https://rubygems.org'

ruby '~>2.5.3', engine: 'jruby', engine_version: '~>9.2.6.0'

gem 'activerecord'
gem 'activerecord-jdbcmysql-adapter', :platform => :jruby

platforms :mri do
  gem 'mysql2'
  gem 'activerecord-mysql-adapter'
end

gem 'awesome_print'

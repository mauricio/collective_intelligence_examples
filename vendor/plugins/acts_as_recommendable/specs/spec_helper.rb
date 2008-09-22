ENV['RAILS_ENV'] ||= 'test'

require 'rubygems'
require 'sqlite3'
require 'activerecord'

require 'spec'

require File.dirname(__FILE__) + '/../init'
require File.dirname(__FILE__) + '/migration'
tmp_dir = File.dirname(__FILE__) + '/../temp'

ActiveRecord::Base.logger = Logger.new(  tmp_dir  + '/acts_as_recommended_spec.log', 'daily' )

# connect to database.  This will create one if it doesn't exist
MY_DB_NAME = tmp_dir + "/acts_as_recommended.db"
MY_DB = SQLite3::Database.new(MY_DB_NAME)

# get active record set up
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => MY_DB_NAME)

SpecDatabaseSetup.down
SpecDatabaseSetup.up
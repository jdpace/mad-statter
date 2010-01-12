require 'rubygems'
require 'test/unit'
require 'mocha'
require 'shoulda'

# Load some Rails Essentials before we load MadStatter
RAILS_ROOT = File.join(File.dirname(__FILE__),'..')
require 'active_record'
require 'active_support'
db_config = {
  :adapter  => 'sqlite3',
  :database => 'test/db/test.sqlite3'
}
ActiveRecord::Base.establish_connection(db_config)

# Add our library to the load path and fire it up
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'mad-statter'

class Test::Unit::TestCase
end

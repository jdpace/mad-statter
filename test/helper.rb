require 'rubygems'
require 'test/unit'
require 'mocha'
require 'shoulda'
require 'sqlite3'

# Load some Rails Essentials before we load MadStatter
class Rails; def self.root; File.join(File.dirname(__FILE__),'..') end; end
require 'active_record'
require 'active_support'
db_config = {
  :adapter  => 'sqlite3',
  :database => 'test/db/test.sqlite3'
}
ActiveRecord::Base.establish_connection(db_config)
Time.zone = "Eastern Time (US & Canada)"

# Add our library to the load path and fire it up
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'mad-statter'

class Test::Unit::TestCase
  
  def self.should_have_attr_reader(*attributes)
    context 'In order to give access to public attributes' do
      attributes.each do |attribute|
        should "should have a reader for @#{attribute}" do
          instance = subject
          instance.instance_variable_set "@#{attribute}", 'value'
          assert_equal 'value', instance.send(:"#{attribute}")
        end
      end
    end
  end
  
  def self.should_have_attr_writer(*attributes)
    context 'In order to give access to public attributes' do
      attributes.each do |attribute|
        should "should have a writer for @#{attribute}" do
          instance = subject
          instance.send :"#{attribute}=", 'value'
          assert_equal 'value', instance.instance_variable_get("@#{attribute}")
        end
      end
    end
  end
  
  def self.should_have_attr_accessor(*attributes)
    should_have_attr_reader(*attributes)
    should_have_attr_writer(*attributes)
  end
  
end

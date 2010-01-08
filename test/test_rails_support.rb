require 'helper'

class TestRailsSupport < Test::Unit::TestCase
  
  should 'Add the statistics folder to the load path' do
    assert ActiveSupport::Dependencies.load_paths.include?(File.join(RAILS_ROOT,'app','statistics'))
  end
  
end

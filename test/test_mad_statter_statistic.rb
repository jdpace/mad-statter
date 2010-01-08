require 'helper'

class TestMadStatterStatistic < Test::Unit::TestCase
  
  context 'When Dealing with an instance of MadStatter::Statistic' do
    setup do
      @statistic = MadStatter::Statistic.new
    end
    
    should "raise an error when calling poll" do
      # The poll method is meant to be overridden by the subclass
      assert_raise MadStatter::Statistic::NoPollMethodError do
        @statistic.poll
      end
    end
    
  end
  
end

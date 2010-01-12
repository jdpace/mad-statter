require 'helper'

class TestMadStatterStatistic < Test::Unit::TestCase
  
  context 'When Dealing with an instance of MadStatter::Statistic' do
    setup do
      @statistic = MadStatter::Statistic.new
    end
    
    should "raise an error when calling poll" do
      # The poll method is meant to be overridden by the subclass
      assert_raise MadStatter::NoPollMethodError do
        @statistic.poll
      end
    end
  end
  
  context 'When defining some meta attributes' do
    setup do
      MadStatter::Statistic.desc    'Test Description'
      MadStatter::Statistic.rate    :hour
      MadStatter::Statistic.rollup  :average
    end
    
    should 'have the correct description set' do
      assert_equal 'Test Description', MadStatter::Statistic.description
    end
    
    should 'have the correct poll rate set' do
      assert_equal :hour, MadStatter::Statistic.poll_rate
    end
    
    should 'have the correct rollup method set' do
      assert_equal :average, MadStatter::Statistic.rollup_method
    end
  end
  
  context 'When working with a storage adapter' do
    setup do
      MadStatter::Statistic.storage_adapter = nil
    end
    
    should 'default to the ActiveRecord storage adapter' do
      assert_equal MadStatter::Storage::ActiveRecord, MadStatter::Statistic.storage_adapter
    end
  end
  
  context 'When being saved' do
    setup do
      @statistic = MadStatter::Statistic.new
      MadStatter::Statistic.storage_adapter.expects(:save_statistic).
        with(@statistic).returns(true)
    end
    
    should 'call the appropriate storage adpaters save_statistic method' do
      assert @statistic.save
    end
  end
  
end

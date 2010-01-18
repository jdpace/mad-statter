require 'helper'

class TestMadStatterStatistic < Test::Unit::TestCase
  
  subject { MadStatter::Statistic.new }
  
  context 'When Dealing with an instance of MadStatter::Statistic' do
    setup do
      @before    = Time.zone.now
      @statistic = MadStatter::Statistic.new
      @after     = Time.zone.now
    end
    
    should_have_attr_accessor :time, :quantity, :factor, :scale
    
    should "raise an error when calling poll" do
      # The poll method is meant to be overridden by the subclass
      assert_raise MadStatter::NoPollMethodError do
        @statistic.poll
      end
    end
    
    should "set the scale to the classes poll_rate" do
      assert_equal @statistic.class.poll_rate, @statistic.scale
    end
    
    should "prepopulate the time with the current time" do
      assert @statistic.time >= @before
      assert @statistic.time <= @after
    end
    
    context 'and polling the stat to be saved' do
      setup do
        @statistic.expects(:poll).returns(1)
        @statistic.expects(:save).returns(true)
        @statistic.poll!
      end
      
      should 'set the quantity to the polled return value' do
        assert_equal 1, @statistic.quantity
      end
    end
  end
  
  context 'When defining some meta attributes' do
    setup do
      MadStatter::Statistic.desc        'Test Description'
      MadStatter::Statistic.rate        :hour
      MadStatter::Statistic.rollup      :average
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
  
  context 'Dealing with factors' do
    context 'when no factors are set' do
      setup do
        MadStatter::Statistic.has_factors nil
      end
    
      should 'return an array with nil as the factors' do
        assert_equal [nil], MadStatter::Statistic.factors
      end
    end
    
    
    context 'when an array of objects are set as the factors' do
      setup do
        @factors = [Object.new, Object.new, Object.new]
        MadStatter::Statistic.has_factors @factors
      end
      
      should 'return the array when calling factors' do
        assert_equal @factors, MadStatter::Statistic.factors
      end
    end
    
    
    context 'when a proc is assigned to the factors' do
      setup do
        @proc = lambda { (1..3).to_a }
        MadStatter::Statistic.has_factors @proc
      end
      
      should 'return the result of the proc when calling factors' do
        assert_equal @proc.call, MadStatter::Statistic.factors
      end
    end
  end
  
  context 'When being saved' do
    setup do
      @statistic = MadStatter::Statistic.new
      MadStatter::Statistic.storage_adapter.expects(:save_statistic).returns(true)
    end
    
    should 'call the appropriate storage adpaters save_statistic method' do
      assert @statistic.save
    end
  end
  
  
  context 'When being harvested' do
    setup do
      @poll_time = Time.zone.now
      @factors = (1..3).to_a
      @stat = MadStatter::Statistic.new
      @stat.expects(:poll!).times(3).returns(true)
      MadStatter::Statistic.expects(:factors).returns(@factors)
      MadStatter::Statistic.expects(:new).times(3).returns(@stat)
      MadStatter::Statistic.harvest(@poll_time)
    end
    
    should 'set the appropriate poll time' do
      assert_equal @poll_time, @stat.time
    end
    
    should 'set the factor' do
      assert_equal @factors.last, @stat.factor
    end
  end
  
end

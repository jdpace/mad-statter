require 'helper'

class TestMadStatterPoller < Test::Unit::TestCase
  
  subject { MadStatter::Poller.new(Time.zone.now) }
  
  should_have_attr_writer   :scale
  should_have_attr_accessor :poll_time
  
  context 'Dealing with a Poller instance' do
    setup do
      @time   = Time.zone.now
      @poller = MadStatter::Poller.new(@time)
    end
    
    should 'record the proper poll time' do
      assert_equal @time, @poller.poll_time
    end
    
    should 'default the scale with one based on the poll time' do
      assert_equal @poller.send(:determine_scale), @poller.scale
    end
    
    context 'being run' do
      setup do
        @poller.scale = :month
        @poller.run
      end
      
      before_should 'call harvest for all the matching stats' do
        MadStatter::MinutelyStat.expects(:harvest).with(@time).returns(true)
        MadStatter::HourlyStat.expects(:harvest).with(@time).returns(true)
        MadStatter::DailyStat.expects(:harvest).with(@time).returns(true)
        MadStatter::MonthlyStat.expects(:harvest).with(@time).returns(true)
      end
    end
  end
  
  
  context 'When determining the scale of the poller' do
    setup do
      @poller = MadStatter::Poller.new(Time.zone.now)
    end
    
    context 'and the poll time is not at the top of the hour' do
      setup do
        @poller.poll_time = DateTime.parse('10/10/2010 10:10PM')
      end
      
      should 'have a scale of :minute' do
        assert_equal :minute, @poller.scale
      end
    end
    
    
    context 'and the poll time is at the top of the hour' do
      setup do
        @poller.poll_time = DateTime.parse('01/18/2010 3:00PM')
      end
      
      should 'have a scale of :hour' do
        assert_equal :hour, @poller.scale
      end
    end
    
    context 'and the poll time is not at the top of the day' do
      setup do
        @poller.poll_time = DateTime.parse('07/15/1985 12:00AM')
      end
      
      should 'have a scale of :day' do
        assert_equal :day, @poller.scale
      end
    end
    
    
    context 'and the poll time is not at the top of the month' do
      setup do
        @poller.poll_time = DateTime.parse('01/01/2010 12:00AM')
      end
      
      should 'have a scale of :month' do
        assert_equal :month, @poller.scale
      end
    end
    
  end
  
  
  context 'When determining the scale stack to run against' do
    setup do
      @poller = MadStatter::Poller.new(Time.zone.now)
    end
    
    context 'and the scale is :minute' do
      setup do
        @poller.scale = :minute
      end
      
      should 'return the proper scale stack' do
        assert_equal [:minute], @poller.scale_stack
      end
    end
    
    context 'and the scale is :hour' do
      setup do
        @poller.scale = :hour
      end
      
      should 'return the proper scale stack' do
        assert_equal [:minute,:hour], @poller.scale_stack
      end
    end
    
    context 'and the scale is :day' do
      setup do
        @poller.scale = :day
      end
      
      should 'return the proper scale stack' do
        assert_equal [:minute,:hour,:day], @poller.scale_stack
      end
    end
    
    context 'and the scale is :month' do
      setup do
        @poller.scale = :month
      end
      
      should 'return the proper scale stack' do
        assert_equal [:minute,:hour,:day,:month], @poller.scale_stack
      end
    end
    
  end
  
  
  context 'Dealing with Statisitc Classes' do
    setup do
      @klasses = [MadStatter::MinutelyStat, MadStatter::HourlyStat, MadStatter::DailyStat, MadStatter::MonthlyStat]
      @poller  = MadStatter::Poller.new(Time.zone.now)
    end
    
    should 'be able to fine all the classes' do
      assert_same_elements @klasses, @poller.statistic_klasses
    end
    
    should 'be able to find the correct stats for the :minute scale' do
      assert_equal [MadStatter::MinutelyStat], @poller.stats_at_scale(:minute)
    end
  end
  
end

class MadStatter::MinutelyStat < MadStatter::Statistic; rate :minute; end
class MadStatter::HourlyStat < MadStatter::Statistic;   rate :hour;   end
class MadStatter::DailyStat < MadStatter::Statistic;    rate :day;    end
class MadStatter::MonthlyStat < MadStatter::Statistic;  rate :month;  end

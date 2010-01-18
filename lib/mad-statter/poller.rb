module MadStatter
  
  class Poller
    
    attr_writer   :scale
    attr_accessor :poll_time
    
    def initialize(time)
      self.poll_time = time
    end
    
    # Harvests each statistic in the current scale stack.
    def run
      scale_stack.each do |current_scale|
        stats_at_scale(current_scale).each do |klass|
          klass.harvest(poll_time)
        end
      end
    end
    
    def scale
      @scale ||= determine_scale
    end
    
    # Returns the full stack of scales to run.
    # Includes all scales smaller then the current scale
    # Examples - given a scale
    # :day => [:minute, :hour, :day]
    # :minute => [:minute]
    def scale_stack
      @scale_stack ||= MadStatter::Statistic::RATES.slice(0..MadStatter::Statistic::RATES.index(scale))
    end
    
    # Returns a subset of statistic classes that have a given poll rate
    def stats_at_scale(scale)
      statistic_klasses.reject {|stat| stat.poll_rate != scale}
    end
    
    # Returns an array of classes that subclass MadStatter::Statistic
    def statistic_klasses
      @statistic_klasses ||= MadStatter::Statistic.subclasses.map {|klass_name| klass_name.constantize}
    end
    
    protected
      
      # Given the poll time, return the highest scale to run.
      #
      # Examples
      # 01/31/2010 12:13:XX - :minute
      # 01/31/2010 12:00:XX - :hour
      # 01/31/2010 00:00:XX - :day
      # 02/01/2010 00:00:XX - :month
      def determine_scale
        t = poll_time
        if t.min.zero? && t.hour.zero? && t.day == 1
          :month
        elsif t.min.zero? && t.hour.zero?
          :day
        elsif t.min.zero?
          :hour
        else
          :minute
        end
      end
  end
  
end
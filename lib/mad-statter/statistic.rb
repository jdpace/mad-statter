module MadStatter
  
  class NoPollMethodError < StandardError
    def initialize
      super "No poll method defined. Each Statistic subclass must define its own poll method."
    end
  end

  class Statistic
    ROLLUP_OPTIONS  = [:sum, :average, :none]
    RATE_OPTIONS    = [:minute, :hour, :day, :month, :manual]
    
    cattr_reader    :description, :rollup_method, :poll_rate
    cattr_accessor  :storage_adapter
    
    attr_accessor :time, :quantity, :factor, :scale
    
    # Default the storage adapter for Statistics to ActiveRecord
    def self.storage_adapter
      @@storage_adapter ||= MadStatter::Storage::ActiveRecord
    end
    
    # Set a detailed description to be used in views and reports
    def self.desc(msg)
      @@description = msg
    end

    # Define the method in which statistics are rolled up
    #
    # Options: :sum, :average, :none
    def self.rollup(meth)
      @@rollup_method = meth.to_sym if ROLLUP_OPTIONS.include?(meth.to_sym)
    end

    # Set the poll rate for this statistic
    #
    # Options: :minute, :hour, :day, :month, :manual
    #
    # If poll rate is set to :minute ensure that
    # the polling takes less than a minute to complete
    #
    # If no poll rate is set then polling will be manual
    def self.rate(r)
      @@poll_rate = r.to_sym if RATE_OPTIONS.include?(r.to_sym)
    end
    
    # This method is meant to be overridden by your own
    # Statistic class. It is responsible for running your
    # metric and returning a numeric value to be recorded.
    def poll
      raise NoPollMethodError.new
    end
    
    # Saves this statistic using the configured storage adapter
    def save
      self.class.storage_adapter.save_statistic(
          self.class.name,
          scale,
          time,
          factor,
          quantity
        )
    end
    
  end

end
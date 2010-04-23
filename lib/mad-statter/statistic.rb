module MadStatter
  
  class NoPollMethodError < StandardError
    def initialize
      super "No poll method defined. Each Statistic subclass must define its own poll method."
    end
  end

  class Statistic
    ROLLUPS  = [:sum, :average, :none]
    RATES    = [:minute, :hour, :day, :month, :manual]
    
    cattr_accessor  :storage_adapter
    class_inheritable_reader    :description, :rollup_method, :poll_rate
    
    attr_accessor :time, :quantity, :factor, :scale
    
    # Default the storage adapter for Statistics to ActiveRecord
    def self.storage_adapter
      @@storage_adapter ||= MadStatter::Storage::ActiveRecord
    end
    
    # Set a detailed description to be used in views and reports
    def self.desc(msg)
      write_inheritable_attribute :description, msg
    end

    # Define the method in which statistics are rolled up
    #
    # Options: :sum, :average, :none
    def self.rollup(meth)
      write_inheritable_attribute(:rollup_method, meth.to_sym) if ROLLUPS.include?(meth.to_sym)
    end
    
    # Meta style method for defining Factors (if any)
    # Accepts either a regular Enumerabl object or
    # a proc that will only be called when calling 'factors'
    def self.has_factors(enum_or_proc)
      @factors = enum_or_proc
    end
    
    # Returns a set of factors
    # If no factors were defined returns
    # an array containing a single nil
    def self.factors
      @factors ||= [nil]
      @factors.respond_to?(:call) ? @factors.call : @factors
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
      write_inheritable_attribute(:poll_rate, r.to_sym) if RATES.include?(r.to_sym)
    end
    
    # Harvest the statistics across the set factors
    def self.harvest(poll_time)
      self.factors.each do |factor|
        stat = self.new
        stat.time   = poll_time
        stat.factor = factor
        stat.poll!
      end
    end
    
    # Record all subclasses
    def self.inherited(subclass)
      @@subclasses ||= []
      @@subclasses << subclass
    end
    
    def self.subclasses
      @@subclasses
    end
    
    def initialize
      self.scale = self.class.poll_rate
      self.time  = Time.zone.now
    end
    
    # This method is meant to be overridden by your own
    # Statistic class. It is responsible for running your
    # metric and returning a numeric value to be recorded.
    def poll
      raise NoPollMethodError.new
    end
    
    # Record the result of the poll method and save this stat
    # using the correct storage adapter
    def poll!
      self.quantity = poll
      self.save
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
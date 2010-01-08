module MadStatter

  class Statistic < ActiveRecord::Base
    self.abstract_class = true
    
    class NoPollMethodError < StandardError
      def initialize
        super "No poll method defined. Each Statistic class must define its own poll method."
      end
    end
    
    def poll
      raise NoPollMethodError
    end
    
  end

end
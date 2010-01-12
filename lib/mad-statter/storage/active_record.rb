module MadStatter
  
  module Storage
    
    class ActiveRecord < ActiveRecord::Base
      
      set_table_name 'statistics'
      
      belongs_to :factor, :polymorphic => true
      
      # saves a statistic to the database
      def self.save_statistic(statistic)
        writer = MadStatter::Storage::ActiveRecord.new
        
        writer.statistic_type = statistic.class.name
        writer.time           = statistic.time
        writer.quantity       = statistic.quantity
        writer.scale          = statistic.scale
        writer.factor         = statistic.factor
        
        writer.save
      end
      
    end
    
  end
  
end
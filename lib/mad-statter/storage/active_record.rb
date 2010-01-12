module MadStatter
  
  module Storage
    
    class ActiveRecord < ActiveRecord::Base
      
      set_table_name 'statistics'
      
      belongs_to :factor, :polymorphic => true
      
      # saves a statistic to the database
      def self.save(statistic_type, scale, time, factor, quantity)
        writer = MadStatter::Storage::ActiveRecord.new
        
        writer.statistic_type = statistic_type
        writer.scale          = scale
        writer.time           = time
        writer.quantity       = quantity
        
        if factor
          writer.factor_type  = factor.class.name
          writer.factor_id    = factor.id if factor.respond_to?(:id)
        end
        
        writer.save
      end
      
    end
    
  end
  
end
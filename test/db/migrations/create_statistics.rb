class CreateStatistics < ActiveRecord::Migration
  
  def self.up
    create_table :statistics do |t|
      t.string    :statistic_type
      
      t.float     :quantity
      t.datetime  :time
      
      t.string    :factor_type
      t.integer   :factor_id
      
      t.string    :scale,     :limit => 6
    end
    
    add_index :statistics, [:statistic_type, :time]
    add_index :statistics, [:factor_type, :factor_id]
  end
  
  def self.down
    remove_column :statistics, :statistic_type    
    remove_column :statistics, :quantity
    remove_column :statistics, :time
    remove_column :statistics, :factor_type
    remove_column :statistics, :factor_id
    remove_column :statistics, :scale
  end
  
end
module MadStatter
  
  class Railtie < Rails::Railtie
    
    initializer 'madstatter.load_paths' do
      StatisticsRoot = File.join(Rails.root,'app','statistics')
      ActiveSupport::Dependencies.load_paths << StatisticsRoot
    end
    
  end
  
end
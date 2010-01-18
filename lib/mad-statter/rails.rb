begin
  STATISTICS_ROOT = File.join(RAILS_ROOT,'app','statistics')
  ActiveSupport::Dependencies.load_paths << STATISTICS_ROOT
rescue NameError
  puts "No sign of Rails. MadStatter is designed to be used with Rails. Exiting..."
  exit
end
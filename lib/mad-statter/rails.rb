begin
  ActiveSupport::Dependencies.load_paths << File.join(RAILS_ROOT,'app','statistics')
rescue NameError
  puts "No sign of Rails. MadStatter is designed to be used with Rails. Exiting..."
  exit
end
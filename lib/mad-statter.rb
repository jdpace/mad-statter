require 'mad-statter/statistic'
require 'mad-statter/poller'
require 'mad-statter/storage/active_record'

if defined?(::Rails::Railtie)
  require 'mad-statter/railtie'
end
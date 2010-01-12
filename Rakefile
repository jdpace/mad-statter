$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'lib'))
require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "mad-statter"
    gem.summary = %Q{MadStatter: Easy business stats for your rails app}
    gem.description = %Q{TODO: longer description of your gem}
    gem.email = "jared@codewordstudios.com"
    gem.homepage = "http://github.com/jdpace/mad-statter"
    gem.authors = ["Jared Pace"]
    gem.add_development_dependency "shoulda",         ">= 0"
    gem.add_development_dependency "mocha",           ">= 0"
    gem.add_development_dependency "active_record",   ">= 0"
    gem.add_development_dependency "active_support",  ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mad-statter #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :db do
  namespace :test do
    require 'test/helper'
    require 'test/db/migrations/create_statistics'
    
    desc "Migrate a test database using the config in test/helper.rb"
    task :prepare do
      CreateStatistics.migrate(:up)
    end
  end
end
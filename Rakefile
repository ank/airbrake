require 'rubygems'
require 'rake'
require "redis"
require "resque"
require "resque/tasks"

task "resque:setup" => :environment

task :environment do
  DIR = File.dirname(__FILE__)
  $LOAD_PATH.unshift("#{DIR}/lib")
  Dir["#{DIR}/lib/**/*.rb"].each {|lib| require lib }
end

namespace :resque do
  desc 'Show resque info'
  task :info do
    p Resque.info
  end
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "airbrake"
    gem.summary = %Q{web app to automate handbrake video conversion}
    gem.description = %Q{A simple web app built with sinatra to automate handbrake video conversion}
    gem.email = "adamnkraut@gmail.com"
    gem.homepage = "http://github.com/ank/airbrake"
    gem.authors = ["ank"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
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
  rdoc.title = "airbrake #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

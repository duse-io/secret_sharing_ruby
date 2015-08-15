require 'bundler/gem_tasks'
# remove release task
Rake::Task["release"].clear

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
  puts 'rspec tasks could not be loaded'
end

require 'electron-opal'
require 'opal-rspec'

setup do | config |
  config.paths << File.expand_path('../spec', __FILE__)
  config.paths << File.expand_path('../lib', __FILE__)
end

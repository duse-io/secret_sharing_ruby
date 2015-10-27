require "bundler/gem_tasks"
# Remove release task. We only release via Travis. No manual releases.
Rake::Task["release"].clear

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
  puts "rspec tasks could not be loaded"
end

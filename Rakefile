require 'rspec/core/rake_task'
require './lib/crowdtilt/version'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :test => :spec

task :build do
  system "gem build crowdtilt.gemspec"
end
 
task :release => :build do
  `fury push crowdtilt-#{Crowdtilt::VERSION}.gem`
  `rm crowdtilt-#{Crowdtilt::VERSION}.gem`
end
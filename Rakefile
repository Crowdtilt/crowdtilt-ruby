require 'rspec/core/rake_task'
require './lib/crowdtilt/version'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :build do
  system "gem build crowdtilt.gemspec"
end
 
task :release => :build do
  `fury push crowdtilt-#{Zaarly::Geolocation::VERSION}.gem`
  `rm crowdtilt-#{Zaarly::Geolocation::VERSION}.gem`
end
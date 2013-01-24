# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "crowdtilt/version"

Gem::Specification.new do |s|
  s.name        = "crowdtilt"
  s.version     = Crowdtilt::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ian Hunter"]
  s.email       = ["ianhunter@gmail.com"]
  s.homepage    = "https://github.com/ihunter/crowdtilt"
  s.summary     = "Crowdtilt API library"
  s.description = "Allows access to the Crowdtilt public API"

  s.rubyforge_project = s.name

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activemodel'
  s.add_dependency 'faraday'
  s.add_dependency 'faraday_middleware'
  s.add_dependency 'json'
end

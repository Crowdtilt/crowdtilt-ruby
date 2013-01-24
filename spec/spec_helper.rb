require 'rubygems'
require 'bundler'

$:.push(File.expand_path(File.dirname(__FILE__)))
require './lib/crowdtilt'

Bundler.setup :default, :test
Bundler.require :default, :test
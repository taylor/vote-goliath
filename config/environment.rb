ENV['RACK_ENV'] ||= 'test'

require 'rubygems'
require 'bundler/setup'
Bundler.require :default, ENV['RACK_ENV']

script_path = Dir.chdir(File.expand_path(File.dirname(__FILE__))) { Dir.pwd }
lib_path = Dir.chdir(script_path + '/../lib') { Dir.pwd }
vendor_path = Dir.chdir(script_path + '/../vendor') { Dir.pwd }

$:.unshift lib_path
Dir["#{vendor_path}/*/lib"].map { |l| $:.unshift(l) if File.directory?(l) }

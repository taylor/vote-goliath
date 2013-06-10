#!/usr/bin/env ruby

script_path = Dir.chdir(File.expand_path(File.dirname(__FILE__))) { Dir.pwd }
lib_path = Dir.chdir(script_path + '/../lib') { Dir.pwd }
$:.unshift lib_path
$:.unshift "#{lib_path}/rubyvote/lib/"

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
require 'rubyvote/election'

class TestSpecs < MiniTest::Unit::TestCase
  def test_instance_of
    "test".must_be_instance_of String
  end

  def test_using_assertions
    assert_instance_of String, "test"
  end

  def test_lunch_spot_vote
    #vote_array = [1,2,3,1,1,1,2,3]
    vote_array = ['torchies','torchies','torchies','houndstoothe','bennus','flightpath', 'pacha']
    assert_equal( 'torchies', PluralityVote.new(vote_array).result.winners[0] )
  end
end

#require 'goliath'

#class Hello < Goliath::API
#  def response(env)
#    [200, {}, "Hello World"]
#  end
#end

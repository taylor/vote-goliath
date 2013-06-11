#!/usr/bin/env ruby

require_relative '../config/environment.rb'

require 'rubyvote'

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
require 'goliath/test_helper' 
require 'test/unit'

class PluralVote < Goliath::API
  use Goliath::Rack::Params

  def response(env)
		tally = PluralityVote.new(env.params['votes']) 
    [200, {}, tally.result.winners[0]]
  end
end

class PluralVoteTest < Test::Unit::TestCase
  include Goliath::TestHelper

  def setup
    @err = Proc.new { assert false, "API request failed" }
  end

  def test_query_plurality_vote
    with_api(PluralVote) do
      get_request({:query => {:votes => ['torchies','torchies','torchies','houndstoothe','bennus','flightpath', 'pacha']}}, @err) do |c|
        assert_equal 'torchies', c.response
      end
    end
  end
end

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

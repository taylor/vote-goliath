#!/usr/bin/env ruby

require_relative '../config/environment.rb'
require 'rubyvote'

module Vote 
  class API < Grape::API
    version 'v1', :using => :path
    format :json

    resource 'plural' do
      # TEST: curl -D - 'http://localhost:9000/v1/plural'
      get '/' do
            [ "The plurality voting system is a single-winner voting system often used to elect executive officers or to elect members of a legislative assembly which is based on single-member constituencies. -- http://en.wikipedia.org/wiki/Instant_Runoff_Voting",
              "Try curl -D - 'http://localhost:9000/v1/plural/houndstooth,houndstooth,pacha,vuka,vuka,vuka"]
      end

      # TEST: curl -D - 'http://localhost:9000/v1/plural/houndstooth,houndstooth,pacha,vuka,vuka,vuka'
      get '/:votes' do
        votes=params['votes'].split(',')
        tally = PluralityVote.new(votes)
        tally.result.winners[0]
      end
    end
  end
end


class APIServer < Goliath::API
  def response(env)
    puts env 
    Vote::API.call(env);
  end
end


# Run tests unless in production -- allows starting in production with foreman start
unless ENV['RACK_ENV'] == 'production'

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
require 'goliath/test_helper' 
require 'test/unit'

#class PluralVote < Goliath::API
#  use Goliath::Rack::Params
#
#  def response(env)
#		tally = PluralityVote.new(env.params['votes']) 
#    [200, {}, tally.result.winners[0]]
#  end
#end

class APIServerTest < Test::Unit::TestCase
  include Goliath::TestHelper

  def setup
    @err = Proc.new { assert false, "API request failed" }
  end

  def test_root
    with_api(APIServer) do
      get_request({:path => '/v1/plural/'}, @err) do |c|
        puts c.response
        assert_match(/The plurality voting/, c.response)
      end
    end
  end

  def test_query_plurality_vote
    with_api(APIServer) do
      get_request({:path => '/v1/plural/houndstooth,houndstooth,pacha,vuka,vuka,vuka'}, @err) do |c|
        puts c.response
        assert_equal '"vuka"', c.response
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

end

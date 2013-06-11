#!/usr/bin/env ruby

script_path = Dir.chdir(File.expand_path(File.dirname(__FILE__))) { Dir.pwd }
require_relative "#{script_path}/config/environment.rb"

require 'goliath'
require 'grape'
require 'rubyvote'
require 'json'

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
        votes.compact!
        votes.reject! &:empty?
        return [] if votes.empty?
        tally = PluralityVote.new(votes)
        tally.result.winners
      end
    end

    # TODO: add alias to ivr as runoff
    resource 'ivr' do
      # TEST: curl -D - 'http://localhost:9000/v1/plural'
      get '/' do
            [ "Instant-runoff voting (IRV), alternative vote (AV), transferable vote, ranked choice voting, or preferential vote is an electoral system used to elect a single winner from a field of more than two candidates",
              "Try curl -D - 'http://localhost:9000/v1/ivr/...."]
      end

      get '/:votes' do
        # NOTE: expects json...
        votes=JSON.parse(params['votes'])
        votes.compact!
        votes.reject! &:empty?
        return [] if votes.empty?
        tally = InstantRunoffVote.new(votes)
        tally.result.winners
      end
    end
  end
end


class APIServer < Goliath::API
  def response(env)
    Vote::API.call(env);
  end
end

#!/usr/bin/env ruby

script_path = Dir.chdir(File.expand_path(File.dirname(__FILE__))) { Dir.pwd }
require_relative "#{script_path}/config/environment.rb"

require 'goliath'
require 'grape'
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
        votes.compact!
        votes.reject! &:empty?
        $stderr.puts votes.inspect
        tally = PluralityVote.new(votes)
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

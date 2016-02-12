require './test/test_helper'
require 'rack/test'
require 'sinatra/base'
require 'api'

class APITest < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  include WithRollback

  def app
    EpisodeXAPI
  end

  # TODO
  def test_hello_world
    
  end
end

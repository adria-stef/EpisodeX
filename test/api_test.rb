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
    # temporarily do
      new_password = BCrypt::Password.create("pass")

      User.create(:email => "some_email", :hashed_password => new_password)
      get '/users'
      expected = ""
      assert_equal expected, last_response.body
    end
  # end
end

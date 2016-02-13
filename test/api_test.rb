require './test/test_helper'

class APITest < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  include WithRollback

  def app
    EpisodeXAPI
  end

  def test_create_initial_user
    users = User.all.size
      if users < 1
        new_password = BCrypt::Password.create("pass")

        User.create(:email => "init", :hashed_password => new_password)
        users = User.all.size
        expected = 1
        assert_equal expected, users
      end
  end

  def test_root_unathorized
      get "#{ENV['TEST_URL']}/logout"
      get "#{ENV['TEST_URL']}/"
      expected = 302
      assert_equal expected, last_response.status
  end

  def test_login
      get "#{ENV['TEST_URL']}/login"
      expected = 200
      assert_equal expected, last_response.status
  end

  def test_register
      get "#{ENV['TEST_URL']}/register"
      expected = 200
      assert_equal expected, last_response.status
  end

  def test_next_unathorized
    get "#{ENV['TEST_URL']}/next"
    expected = 302
    assert_equal expected, last_response.status
  end

end

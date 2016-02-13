$LOAD_PATH.unshift File.expand_path('./../../lib', __FILE__)

ENV['RACK_ENV'] = 'test'

require './config/environment'
require 'minitest/autorun'
require 'minitest/reporters'
require 'rack/test'
require 'sinatra/base'
require 'api'

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

module WithRollback
  def temporarily(&block)
    ActiveRecord::Base.connection.transaction do
      yield
      fail ActiveRecord::Rollback
    end
  end
end

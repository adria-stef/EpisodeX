$LOAD_PATH.unshift File.expand_path('./../lib', __FILE__)

require 'bundler'
Bundler.require

require './config/environment'
require 'sinatra/base'
require 'puma'

require 'api'

use ActiveRecord::ConnectionAdapters::ConnectionManagement

require 'rack/protection'
use Rack::Protection::XSSHeader
use Rack::Protection::EscapedParams

use Rack::Protection::IPSpoofing
use Rack::Protection::PathTraversal
use Rack::Protection::HttpOrigin
use Rack::Protection::RemoteReferrer
use Rack::Protection::JsonCsrf
use Rack::Protection::FrameOptions

run EpisodeXAPI

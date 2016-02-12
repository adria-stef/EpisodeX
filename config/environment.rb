require 'bundler'
Bundler.require

require 'yaml'
require 'episodex/db_config'

environment = ENV.fetch('RACK_ENV') { 'development' }
config = DBConfig.new(environment).options
ActiveRecord::Base.establish_connection(config)

require 'models/user'
require 'models/tv_shows'
require 'bcrypt'

require 'themoviedb'
Tmdb::Api.key('562d0cb5578d9c514772ea826b3dcf60')

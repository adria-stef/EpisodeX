require 'routes/users_api'
require 'routes/tv_shows_api'

# API
class EpisodeXAPI < Sinatra::Base
  set :views, proc { File.join(root, '../views') }
  configure do
    enable :sessions
  end
end

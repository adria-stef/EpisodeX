require 'routes/users_api'
require 'routes/tv_shows_api'

class EpisodeXAPI < Sinatra::Base
  set :views, Proc.new { File.join(root, "../views") }
  configure do
    enable :sessions
  end
end

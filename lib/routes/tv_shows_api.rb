# TV Shows API
class EpisodeXAPI < Sinatra::Base

  get '/' do
    session!
    shows = TvShows.where(:user => session[:username]).all #:order => :name.desc
    erb :home, :locals => { :shows => shows }
  end

  def my_shows
    TvShows.where(:user => session[:username])
  end

  get '/next' do
    session!
    shows = TvShows.where(:user => session[:username]).all #:order => :name.desc
    erb :next, :locals => { :shows => shows }
  end

  get '/search' do
    session!
    erb :search
  end

  get '/searchShows' do
    session!
    name = params[:search]
    search = Tmdb::Search.new
    search.resource('tv')
    search.query(name)
    shows = search.fetch

    erb :search, :locals => { :shows => shows }
  end

  get '/findShow/:id' do
    session!
    show = Tmdb::TV.detail(params['id'].to_i)
    show.to_json
  end

  # TODO separate business logic
  def next_episodes(show, name, id)
    db_show = TvShows.where(:user => session[:username]).where(:name => name).first

  if !db_show.nil?
      last_season = TvShows.where(:user => session[:username]).where(:name => name).first.season
      last_episode = TvShows.where(:user => session[:username]).where(:name => name).first.episode
    else
      last_season = 1
      last_episode = 1
    end

    current_season = Tmdb::Season.detail(id, last_season)
    if !current_season['episodes'].nil?
      episodes = current_season['episodes'][last_episode.to_i, current_season['episodes'].length]

      number_of_seasons = show['number_of_seasons']
      ((last_season.to_i + 1)..number_of_seasons.to_i).each do |season_number|
        season = Tmdb::Season.detail(id, season_number)
        new_episodes = season['episodes'][0, season['episodes'].length]
        episodes.concat(new_episodes)
      end
      episodes
    else
      nil
    end
  end

  get '/viewShow/:name' do
    session!
    name = params[:name]
    redirect "/view?name=#{name}"
  end

  get '/view' do
    session!
    name = params[:name]
    id = TvShows.where(:name => name).first.db_id
    show = Tmdb::TV.detail(id)

    episodes = next_episodes(show, name, id)

    erb :show, :locals => { :show => show, :episodes => episodes }
  end

  def find_id(name)
    search = Tmdb::Search.new
    search.resource('tv')
    search.query(name)
    if !search.fetch.nil? and !search.fetch.first.nil?
      search.fetch.first['id']
    else
      0
    end
  end

  # TODO
  def invalid_name(name, id)
    show = Tmdb::TV.detail(id)
    !(name.downcase == show['name'].downcase || ('the ' << name.downcase) == show['name'].downcase)
  end

  def get_name(id)
    show = Tmdb::TV.detail(id)
    show['name']
  end

  def check_name(name)
    name.strip
  end

  post '/addShow' do
    session!
    checked_name = check_name(params[:name])
    id = find_id(checked_name)
    name = get_name(id)

    show = Tmdb::TV.detail(id)
    episodes = next_episodes(show, name, id)
    if id < 1 or invalid_name(name, id)
      erb :not_found
    else
      TvShows.create(:user => session[:username], :name => name, :db_id => id, :season => "1", :episode => "1", :next_episodes => episodes.size.to_s, :pic => show['poster_path'])
      redirect '/'
    end
  end

  get '/updateShow' do
    session!
    TvShows.where(:user => session[:username]).where(:name => "arrow").first.update_attributes(:season => "5", :episode => "6")
  end

  post '/watchNext/:name' do
    session!
    # TODO
    name = params[:name]
    id = TvShows.where(:user => session[:username]).where(:name => name).first.db_id
    show = Tmdb::TV.detail(id)

    episodes = next_episodes(show, name, id)
    season_number = episodes.first['season_number']
    episode_number = episodes.first['episode_number']

    episodes_left = episodes.size - 2

    TvShows.where(:user => session[:username]).where(:name => name).
    first.update_attributes(:season => season_number.to_s, :episode => episode_number.to_s, :next_episodes => episodes_left.to_s)
    redirect back
  end

  get '/removeShow/:name' do
    session!
    TvShows.where(:user => session[:username]).where(:name => params[:name]).first.delete
    redirect '/'
  end

end

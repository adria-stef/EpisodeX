class EpisodeXAPI < Sinatra::Base


  get '/' do
    @shows = TvShows.where(:user => @@current).all #:order => :name.desc
    @title = 'My Shows'
    erb :home
  end

  get '/myShows' do
      a = "You're welcome, #{@@current}\n"
      TvShows.where(:user => @@current).each{ |show|
        a << show.to_json
      }
      a
  end

  def find_id(name)
    search = Tmdb::Search.new
    search.resource('tv')
    search.query(name)
    search.fetch.first['id']
  end

  get '/search/:name' do
    id = find_id(params[:name])

    show = Tmdb::TV.detail(id)
    a = ""
    show.each{|key, value|
      a << "#{key} is #{value}" << "\n"
    }
    a
  end

# TODO
  get '/addShow' do
    TvShows.create(:user => @@current, :name => "arrow", :season => "4", :episode => "1")
  end

  get '/updateShow' do
    TvShows.where(:user => @@current).where(:name => "arrow").first.update_attributes(:season => "5", :episode => "6")
  end

  post '/watchNext/:name' do
    # TODO
    season = TvShows.where(:user => @@current).where(:name => params[:name]).first.season
    episode = TvShows.where(:user => @@current).where(:name => params[:name]).first.episode.to_i + 1

    TvShows.where(:user => @@current).where(:name => params[:name]).first.update_attributes(:season => season.to_s, :episode => episode.to_s)
    redirect "/"
  end

  get '/deleteShow' do
    TvShows.where(:user => @@current).where(:name => "arrow").first.delete
  end


end

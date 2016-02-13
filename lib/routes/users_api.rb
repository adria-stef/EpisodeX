require 'sinatra/base'
require 'sinatra/session'
class EpisodeXAPI < Sinatra::Base
  include BCrypt

  register Sinatra::Session

  set :session_fail, '/login'
  set :session_secret, 'So0perSeKr3t!'

  get '/login' do
    if session?
      redirect '/'
    else
      erb :login
    end
  end

  post "/login" do
    User.all.each{ |user|
      if (params[:email] == user.email && BCrypt::Password.new(user.hashed_password) == params[:password])
        session_start!
        session[:username] = params[:email]
        redirect "/"
      end
    }
    erb :login_fail
  end

  get '/logout' do
    session_end!
    redirect '/'
  end

  get '/register' do
    if session?
      redirect '/'
    else
      erb :register
    end
  end

  post "/register" do

    begin
      if (params[:password] == params[:second_password])
        new_password = BCrypt::Password.create(params[:password])
        User.create(:email => params[:email], :hashed_password => new_password)
        redirect '/login'
      else
        erb :passwords_not_match
      end
    rescue
      erb :name_taken
    end
    redirect "/register"
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end


end

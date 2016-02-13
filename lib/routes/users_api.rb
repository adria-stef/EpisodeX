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

  def check_password(pass, second_pass)
    equal = (pass == second_pass)
    long_enough = (pass.length > 3)

    equal and long_enough
  end

  post "/register" do

    begin
      if (params[:password] == params[:second_password] and params[:password].length > 4)
        new_password = BCrypt::Password.create(params[:password])
        User.create(:email => params[:email], :hashed_password => new_password)
        redirect '/login'
      else
        redirect '/passFail'
      end
    rescue
      redirect '/nameTaken'
    end
    redirect "/register"
  end

  get '/passFail' do
    erb :password_fail
  end

  get '/nameTaken' do
    erb :name_taken
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end


end

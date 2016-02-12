class EpisodeXAPI < Sinatra::Base

  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    flag = false

    User.all.each{ |user|
      if (username == user.email && BCrypt::Password.new(user.hashed_password) == password)
        flag = true
        @@current = username
      end
    }

    flag
  end

end

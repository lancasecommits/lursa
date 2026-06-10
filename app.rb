require "sinatra"
require "bcrypt"
require "securerandom"
require "dotenv/load"

set :bind, '0.0.0.0'

require_relative "db"
require_relative "models/user"

enable :sessions
set :session_secret, ENV.fetch("SESSION_SECRET") { raise "SESSION_SECRET não definido! Crie um arquivo .env" }

use Rack::MethodOverride

helpers do
  def current_user
    return nil unless session[:user_id]
    User.from_row(DB[:users].where(id: session[:user_id]).first)
  end

  def logged_in?
    !current_user.nil?
  end

  def admin?
    logged_in? && current_user.admin?
  end

  def require_login!
    redirect "/login" unless logged_in?
  end

  def require_admin!
    redirect "/" unless admin?
  end
end

require_relative "routes/public"
require_relative "routes/auth"
require_relative "routes/profile"
require_relative "routes/discard"
require_relative "routes/admin"

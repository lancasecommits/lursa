get "/login" do
  redirect "/profile" if logged_in?
  erb :login
end

post "/login" do
  user = User.from_row(DB[:users].where(email: params[:email].to_s.strip.downcase).first)

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect session.delete(:after_login) || "/profile"
  else
    @error = "Email ou senha incorretos."
    erb :login
  end
end

get "/signup" do
  redirect "/profile" if logged_in?
  erb :signup
end

post "/signup" do
  name  = params[:name].to_s.strip
  email = params[:email].to_s.strip.downcase

  if DB[:users].where(email: email).any?
    @error = "Já existe uma conta com esse email."
    return erb :signup
  end

  if name.empty? || email.empty? || params[:password].to_s.length < 6
    @error = "Preencha todos os campos. A senha deve ter no mínimo 6 caracteres."
    return erb :signup
  end

  id = DB[:users].insert(
    name:            name,
    email:           email,
    password_digest: BCrypt::Password.create(params[:password]),
    role:            "user",
    points:          0
  )
  session[:user_id] = id
  redirect session.delete(:after_login) || "/profile"
end

get "/logout" do
  session.clear
  redirect "/"
end

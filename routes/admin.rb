get "/admin" do
  require_admin!
  @users_count    = DB[:users].count
  @posts_count    = DB[:posts].count
  @products_count = DB[:products].count
  erb :admin
end

# Posts
get "/admin/posts/new" do
  require_admin!
  erb :new_post
end

post "/admin/posts" do
  require_admin!
  title   = params[:title].to_s.strip
  content = params[:content].to_s.strip

  if title.empty? || content.empty?
    @error = "Título e conteúdo são obrigatórios."
    return erb :new_post
  end

  DB[:posts].insert(title: title, content: content)
  redirect "/blog"
end

delete "/admin/posts/:id" do
  require_admin!
  DB[:posts].where(id: params[:id]).delete
  redirect "/blog"
end

# Produtos
get "/admin/products/new" do
  require_admin!
  erb :new_product
end

post "/admin/products" do
  require_admin!
  name   = params[:name].to_s.strip
  desc   = params[:description].to_s.strip
  points = params[:points].to_i

  if name.empty? || points <= 0
    @error = "Nome e pontos (> 0) são obrigatórios."
    return erb :new_product
  end

  DB[:products].insert(name: name, description: desc, points: points)
  redirect "/catalog"
end

delete "/admin/products/:id" do
  require_admin!
  DB[:products].where(id: params[:id]).delete
  redirect "/catalog"
end

# Pontos de Coleta
get "/admin/points/new" do
  require_admin!
  erb :new_point
end

post "/admin/points" do
  require_admin!
  name    = params[:name].to_s.strip
  address = params[:address].to_s.strip
  lat     = params[:lat].to_f
  lng     = params[:lng].to_f
  pts     = params[:points_per_discard].to_i

  if name.empty? || address.empty? || lat == 0.0 || lng == 0.0 || pts <= 0
    @error = "Preencha todos os campos."
    return erb :new_point
  end

  DB[:collection_points].insert(
    name:               name,
    address:            address,
    lat:                lat,
    lng:                lng,
    token:              SecureRandom.urlsafe_base64(12),
    points_per_discard: pts
  )
  redirect "/points"
end

delete "/admin/points/:id" do
  require_admin!
  DB[:collection_points].where(id: params[:id]).delete
  redirect "/points"
end

# Usuários
get "/admin/users" do
  require_admin!
  @users = DB[:users].order(:name).all
  erb :admin_users
end

post "/admin/users/:id/points" do
  require_admin!
  DB[:users].where(id: params[:id]).update(points: Sequel[:points] + params[:amount].to_i)
  redirect "/admin/users"
end

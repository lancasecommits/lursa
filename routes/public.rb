get "/" do
  @posts    = DB[:posts].order(Sequel.desc(:created_at)).limit(3).all
  @products = DB[:products].order(:points).limit(3).all
  erb :index
end

get "/blog" do
  @posts = DB[:posts].order(Sequel.desc(:created_at)).all
  erb :blog
end

get "/blog/:id" do
  @post = DB[:posts].where(id: params[:id]).first
  halt 404, "Post não encontrado." unless @post
  erb :post
end

get "/catalog" do
  @products = DB[:products].order(:points).all
  erb :catalog
end

get "/points" do
  @points = DB[:collection_points].order(:name).all
  erb :points
end

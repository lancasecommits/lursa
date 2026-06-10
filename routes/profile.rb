get "/profile" do
  require_login!

  @discards = DB[:discards]
    .join(:collection_points, id: :collection_point_id)
    .where(Sequel[:discards][:user_id] => current_user.id)
    .select(
      Sequel[:collection_points][:name],
      Sequel[:collection_points][:points_per_discard],
      Sequel[:discards][:discarded_at]
    )
    .order(Sequel.desc(Sequel[:discards][:discarded_at]))
    .all

  @redemptions = DB[:redemptions]
    .join(:products, id: :product_id)
    .where(Sequel[:redemptions][:user_id] => current_user.id)
    .select(
      Sequel[:products][:name],
      Sequel[:products][:points],
      Sequel[:redemptions][:redeemed_at]
    )
    .order(Sequel.desc(Sequel[:redemptions][:redeemed_at]))
    .all

  erb :profile
end

post "/catalog/:id/redeem" do
  require_login!

  product = DB[:products].where(id: params[:id]).first
  halt 404, "Produto não encontrado." unless product

  user = current_user
  if user.points < product[:points]
    @error = "Pontos insuficientes para resgatar este produto."
    @products = DB[:products].order(:points).all
    return erb :catalog
  end

  DB.transaction do
    DB[:users].where(id: user.id).update(points: Sequel[:points] - product[:points])
    DB[:redemptions].insert(user_id: user.id, product_id: product[:id])
  end

  redirect "/profile"
end

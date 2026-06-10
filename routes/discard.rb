get "/discard/:token" do
  @point = DB[:collection_points].where(token: params[:token]).first
  halt 404, "Ponto de coleta não encontrado." unless @point

  unless logged_in?
    session[:after_login] = "/discard/#{params[:token]}"
    redirect "/login"
  end

  erb :discard
end

post "/discard/:token" do
  require_login!

  point = DB[:collection_points].where(token: params[:token]).first
  halt 404, "Ponto de coleta não encontrado." unless point

  DB.transaction do
    DB[:discards].insert(user_id: current_user.id, collection_point_id: point[:id])
    DB[:users].where(id: current_user.id).update(points: Sequel[:points] + point[:points_per_discard])
  end

  session[:discard_success] = point[:points_per_discard]
  redirect "/discard/#{params[:token]}/done"
end

get "/discard/:token/done" do
  require_login!
  @points_earned = session.delete(:discard_success) || 0
  @point = DB[:collection_points].where(token: params[:token]).first
  @updated_user = User.from_row(DB[:users].where(id: current_user.id).first)
  erb :discard_done
end

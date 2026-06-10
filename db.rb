require "sequel"
require "bcrypt"
require "securerandom"

DB = Sequel.sqlite(ENV.fetch("DATABASE_URL", "lursa.db"))

DB.create_table? :users do
  primary_key :id
  String  :name,            null: false
  String  :email,           null: false, unique: true
  String  :password_digest, null: false
  String  :role,            default: "user"
  Integer :points,          default: 0
end

DB.create_table? :posts do
  primary_key :id
  String   :title,      null: false
  Text     :content,    null: false
  DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
end

DB.create_table? :products do
  primary_key :id
  String  :name,        null: false
  Text    :description
  Integer :points,      null: false, default: 0
end

DB.create_table? :collection_points do
  primary_key :id
  String  :name,               null: false
  String  :address,            null: false
  Float   :lat,                null: false
  Float   :lng,                null: false
  String  :token,              null: false, unique: true
  Integer :points_per_discard, default: 10
end

DB.create_table? :discards do
  primary_key :id
  foreign_key :user_id,             :users,             null: false
  foreign_key :collection_point_id, :collection_points, null: false
  DateTime :discarded_at, default: Sequel::CURRENT_TIMESTAMP
end

DB.create_table? :redemptions do
  primary_key :id
  foreign_key :user_id,    :users,    null: false
  foreign_key :product_id, :products, null: false
  DateTime :redeemed_at, default: Sequel::CURRENT_TIMESTAMP
end

unless DB[:users].where(role: "admin").any?
  admin_email    = ENV.fetch("ADMIN_EMAIL", "admin@lursa.com")
  admin_password = ENV.fetch("ADMIN_PASSWORD", "changeme123")
  DB[:users].insert(
    name:            "Admin",
    email:           admin_email,
    password_digest: BCrypt::Password.create(admin_password),
    role:            "admin",
    points:          0
  )
end

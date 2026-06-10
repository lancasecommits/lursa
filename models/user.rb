require "bcrypt"

class User
  include BCrypt

  attr_accessor :id, :name, :email, :password_digest, :role, :points

  def initialize(id:, name:, email:, password_digest:, role: "user", points: 0)
    @id              = id
    @name            = name
    @email           = email
    @password_digest = password_digest
    @role            = role
    @points          = points
  end

  def authenticate(password)
    Password.new(password_digest) == password
  end

  def admin?
    role == "admin"
  end

  def self.from_row(row)
    return nil unless row
    new(
      id:              row[:id],
      name:            row[:name],
      email:           row[:email],
      password_digest: row[:password_digest],
      role:            row[:role],
      points:          row[:points]
    )
  end
end

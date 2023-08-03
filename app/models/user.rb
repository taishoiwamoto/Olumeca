class User < ApplicationRecord
  has_secure_password

  validates :name, {presence: true}
  validates :email, {presence: true, uniqueness: true}
  validates :password_digest, {presence: true}

  def services
    return Service.where(user_id: self.id)
  end
end

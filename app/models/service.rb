class Service < ApplicationRecord
  validates :title, {presence: true, length: {maximum: 50}}
  validates :user_id, {presence: true}
  validates :category, {presence: true}
  validates :method, {presence: true}
  validates :detail, {presence: true}

  def user
    return User.find_by(id: self.user_id)
  end
end

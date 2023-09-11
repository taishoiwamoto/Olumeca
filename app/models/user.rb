class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :services, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :purchased_orders, class_name: 'Order', foreign_key: 'buyer_id', dependent: :nullify
  has_many :sold_orders, class_name: 'Order', foreign_key: 'seller_id', dependent: :nullify

  # Direct association
  has_many :service_reviews, dependent: :nullify
  # Through associations
  has_many :plans, through: :services
  has_many :indirect_service_reviews, through: :plans, source: :service_reviews

  validates :name,
    presence: { message: ':El nombre del usuario no puede estar vacío.' },
    length: {
    maximum: 50,
    too_long: ':El nombre del usuario debe tener menos de %{count} caracteres.'
  }

  validates :phone_number, presence: true

  def average_service_rating
    self.services.joins(:service_reviews).average('service_reviews.rating')
  end
end

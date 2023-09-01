class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_secure_password
  has_many :services, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :purchased_orders, class_name: 'Order', foreign_key: 'buyer_id', dependent: :nullify
  has_many :sold_orders, class_name: 'Order', foreign_key: 'seller_id', dependent: :nullify
  has_many :service_reviews, dependent: :nullify

  validates :name,
    presence: { message: ':El nombre del usuario no puede estar vacío.' },
    length: {
    maximum: 50,
    too_long: ':El nombre del usuario debe tener menos de %{count} caracteres.'
  }
  validates :email, {
    presence: true,
    uniqueness: true,
    format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: ":Formato de correo electrónico inválido." }
  }

  validates :password, {
    length: { minimum: 8, maximum: 128, too_short: ":La contraseña debe tener al menos %{count} caracteres.",
    too_long: ":La contraseña debe tener menos de %{count} caracteres." },
    if: -> { password.present? }
  }
  validates_format_of :password, {
  with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).+\z/,
  message: ":La contraseña debe contener al menos una letra minúscula, una letra mayúscula, un número y un carácter especial.",
  if: -> { password.present? }
  }

  def services
    return Service.where(user_id: self.id)
  end
end

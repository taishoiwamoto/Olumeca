class Service < ApplicationRecord
  has_many :likes, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :service_reviews, dependent: :nullify


  validates :title,
    presence: { message: ':El nombre del servicio no puede estar vacío.' },
    length: {
      maximum: 65,
      too_long: ':El nombre del servicio debe tener menos de %{count} caracteres.'
    }
  validates :user_id, presence: { message: ':Debe seleccionar al menos un método de provisión.' }
  validates :category, presence: { message: ':La categoría no puede estar vacía.' }
  validates :detail, presence: { message: ':Los detalles no pueden estar vacíos.' }

  def user
    return User.find_by(id: self.user_id)
  end
end

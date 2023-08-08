class Service < ApplicationRecord
  has_many :likes, dependent: :destroy
  belongs_to :user

  validates :title,
    presence: { message: ':El nombre del servicio no puede estar vacío.' },
    length: {
      maximum: 65,
      too_long: ':El nombre del servicio debe tener menos de %{count} caracteres.'
    }
  validates :user_id, presence: { message: ':Debe seleccionar al menos un método de provisión.' }
  validates :category, presence: { message: ':La categoría no puede estar vacía.' }
  validates :service_time, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 60,
      message: ':El tiempo de servicio debe estar entre 1 minuto y 60 minutos.'
  }
  validates :price, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      message: ':El precio debe ser al menos $ 0 MXN.'
  }
  validates :delivery_method, presence: { message: ':Debe seleccionar al menos un método de provisión.' }
  validates :detail, presence: { message: ':Los detalles no pueden estar vacíos.' }

  def user
    return User.find_by(id: self.user_id)
  end
end

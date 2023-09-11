class Service < ApplicationRecord
  has_many :likes, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :plans, dependent: :destroy
  has_many :direct_service_reviews, class_name: 'ServiceReview', dependent: :nullify
  has_many :service_reviews, dependent: :nullify
  has_many :service_reviews, through: :plans
  belongs_to :user

  accepts_nested_attributes_for :plans, allow_destroy: true, reject_if: :all_blank

  validates :title,
    presence: { message: ':El nombre del servicio no puede estar vacío.' },
    length: {
      maximum: 65,
      too_long: ':El nombre del servicio debe tener menos de %{count} caracteres.'
    }
  validates :category, presence: { message: ':La categoría no puede estar vacía.' }
  validates :detail, presence: { message: ':Los detalles no pueden estar vacíos.' }
end

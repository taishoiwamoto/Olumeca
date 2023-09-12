class Service < ApplicationRecord
  belongs_to :user

  has_many :plans, dependent: :destroy, foreign_key: "service_id", inverse_of: :service, autosave: true
  has_many :reviews, through: :plans
  #has_many :reviews, dependent: :nullify
  #has_many :indirect_reviews, through: :plans, source: :reviews
  #has_many :direct_reviews, class_name: 'ServiceReview', dependent: :nullify
  has_many :likes, dependent: :destroy

  accepts_nested_attributes_for :plans, allow_destroy: true#, reject_if: :all_blank

  validates :title,
    presence: { message: ':El nombre del servicio no puede estar vacío.' },
    length: {
      maximum: 65,
      too_long: ':El nombre del servicio debe tener menos de %{count} caracteres.'
    }
  validates :category, presence: { message: ':La categoría no puede estar vacía.' }
  validates :detail, presence: { message: ':Los detalles no pueden estar vacíos.' }
end

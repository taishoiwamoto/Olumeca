class Service < ApplicationRecord
  belongs_to :user
  has_many :orders
  belongs_to :category
  has_many :reviews
  has_many :likes, dependent: :destroy
  has_one_attached :image

  validates :title,
    presence: true,
    length: {
      maximum: 65,
      too_long: ':El nombre del servicio debe tener menos de %{count} caracteres.'
    }
  validates :detail, presence: true

  scope :active, -> { where(deleted_at: nil) }

  def soft_delete
    update_attribute(:deleted_at, Time.now)
  end
end

class Service < ApplicationRecord
  scope :by_keyword, ->(keyword) { active.where("title LIKE ? OR detail LIKE ?", "%#{keyword}%", "%#{keyword}%") }

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

  def average_rating
    average = reviews.pluck('AVG(rating)')[0]
    return average if average.present?

    0
  end

  def count_likes
    likes.length
  end
end

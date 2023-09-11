class Plan < ApplicationRecord
  belongs_to :service
  has_many :service_reviews
  has_many :orders, dependent: :nullify

  validates :title, presence: true, length: { maximum: 255 }
  validates :detail, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :delivery_method, presence: true
end

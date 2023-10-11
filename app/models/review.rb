class Review < ApplicationRecord
  belongs_to :user
  belongs_to :service

  validates :rating, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5,
  }

  validates :user_id, uniqueness: { scope: :service_id, message: "has already reviewed this service" }
end

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :plan, optional: true
  belongs_to :order
  has_one :service, through: :plan

  validates :rating, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5,
  }

  validates :user_id, uniqueness: { scope: :plan_id, message: 'このプランに対しては既にレビューされています。' }
end

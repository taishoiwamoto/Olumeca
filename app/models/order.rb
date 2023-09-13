class Order < ApplicationRecord
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  belongs_to :plan
  has_one :review

  def already_reviewed?(user, order_id)
    Review.exists?(plan_id: plan.id, user_id: user.id, order_id: order_id)
  end
end

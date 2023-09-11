class Order < ApplicationRecord
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  belongs_to :plan
  has_one :service_review
  has_one :service, through: :plan

  def self.find_by_service_and_user(service, user)
    find_by(service: service, buyer: user) || find_by(service: service, seller: user)
  end

  def already_reviewed?(user, order_id)
    ServiceReview.exists?(plan: plan, user: user, order_id: order_id)
  end
end

class Order < ApplicationRecord
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  belongs_to :plan
  #has_one :review
  enum status: ['pending', 'accepted', 'rejected']

  def reviewed_by_user?(user)
    #Review.where(user_id: user.id, order_id: id).exists?
    Review.where(user_id: user.id, service_id: self.plan.service.id).exists?
  end

  def previously_reviewed_by_user?(user)
    return false unless self.plan && self.plan.service
    #Review.joins(:order).where("orders.plan_id IN (?)", self.plan.service.plans.ids).where(user_id: user.id).exists?
    Review.joins(:service).where(service:{id: self.plan.service.id}).where(user_id: user.id).exists?
  end
end

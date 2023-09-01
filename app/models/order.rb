class Order < ApplicationRecord
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id', optional: true
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id', optional: true
  belongs_to :service, optional: true

  def self.find_by_service_and_user(service, user)
    find_by(service: service, buyer: user) || find_by(service: service, seller: user)
  end

  def already_reviewed?(user, order_id)
    ServiceReview.exists?(service: service, user: user, order_id: order_id)
  end
end

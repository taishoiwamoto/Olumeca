class Order < ApplicationRecord
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  belongs_to :service
  enum status: ['pending', 'accepted', 'rejected']

  def reviewed_by_user?(user)
    Review.where(user_id: user.id, service_id: self.service.id).exists?
  end

  def previously_reviewed_by_user?(user)
    return false unless self.service

    Review.joins(:service).where(service:{id: self.service.id}).where(user_id: user.id).exists?
  end
end

class Order < ApplicationRecord
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  belongs_to :service
  enum status: ['pending', 'accepted', 'rejected']

  def service_reviewed_by_user?(user_id)
    Review.find_by(user_id: user_id, service: service).present?
  end

  def review_by_user(user_id)
    Review.find_by(user_id: user_id, service: service)&.id
  end

  def self.service_reviewed_by_user?(user_id, service_id)
    Review.exists?(user_id: user_id, service_id: service_id)
  end

  def self.review_id_by_user(user_id, service_id)
    Review.find_by(user_id: user_id, service_id: service_id)&.id
  end
end

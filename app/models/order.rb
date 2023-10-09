class Order < ApplicationRecord
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  belongs_to :service
  enum status: ['pending', 'accepted', 'rejected']

  def service_reviewed_by_user?(user_id)
    return true if Review.find_by(user_id:, service:).present?

    false
  end

  def review_by_user(user_id)
    Review.find_by(user_id:, service:).id
  end
end

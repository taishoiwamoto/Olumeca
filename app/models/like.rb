class Like < ApplicationRecord
  belongs_to :user
  belongs_to :service

  validates :user_id, :service_id, presence: true

  def self.user_and_service(user_id, service_id)
    return true if find_by(user_id:, service_id:).present?

    false
  end
end

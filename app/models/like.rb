class Like < ApplicationRecord
  validates :user_id, {presence: true}
  validates :service_id, {presence: true}
end

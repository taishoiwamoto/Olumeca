class AddOrderIdToServiceReviews < ActiveRecord::Migration[7.0]
  def change
    add_reference :service_reviews, :order, foreign_key: true
    add_index :service_reviews, [:user_id, :service_id, :order_id], unique: true
  end
end

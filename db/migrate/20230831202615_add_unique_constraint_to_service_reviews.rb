class AddUniqueConstraintToServiceReviews < ActiveRecord::Migration[7.0]
  def change
    add_index :service_reviews, [:user_id, :order_id], unique: true
  end
end

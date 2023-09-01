class RemoveUniqueConstraintFromServiceReviews < ActiveRecord::Migration[7.0]
  def change
    remove_index :service_reviews, [:user_id, :order_id]
  end
end

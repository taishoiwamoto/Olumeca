class RemoveOrderIdFromServiceReviews < ActiveRecord::Migration[7.0]
  def change
    remove_column :service_reviews, :order_id, :integer
  end
end

class RemoveServiceIdFromOrdersAndReviews < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :service_id, :integer
    remove_index :service_reviews, name: "index_service_reviews_on_service_id"
    remove_column :service_reviews, :service_id, :integer
  end
end

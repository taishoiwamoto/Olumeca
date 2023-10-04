class RemoveOrderIndexFromReviews < ActiveRecord::Migration[7.0]
  def change
  	remove_index :reviews, name: "index_reviews_on_order_id"
  end
end

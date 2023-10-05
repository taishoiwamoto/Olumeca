class RemoveOrderIdFromReviews < ActiveRecord::Migration[7.0]
  def change
  	remove_column :reviews, :order_id, :integer
  end
end

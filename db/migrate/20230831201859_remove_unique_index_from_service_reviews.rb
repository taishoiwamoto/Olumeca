class RemoveUniqueIndexFromServiceReviews < ActiveRecord::Migration[7.0]
  def change
    remove_index :service_reviews, [:user_id, :service_id, :order_id]  # この行でユニーク制約を削除
  end
end

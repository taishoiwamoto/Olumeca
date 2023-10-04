class RemovePlanIndexFromReviews < ActiveRecord::Migration[7.0]
  def change
    remove_index :reviews, name: "index_reviews_on_plan_id"
    remove_column :reviews, :plan_id, :integer
  end
end

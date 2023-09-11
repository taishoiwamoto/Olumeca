class AddPlanIdToOrdersAndServiceReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :plan_id, :integer
    add_index :orders, :plan_id

    add_column :service_reviews, :plan_id, :integer
    add_index :service_reviews, :plan_id
  end
end

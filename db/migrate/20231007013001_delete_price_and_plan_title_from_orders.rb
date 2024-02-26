class DeletePriceAndPlanTitleFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :price
    remove_column :orders, :plan_title
  end
end

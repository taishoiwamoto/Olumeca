class DeletePlanIdFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_reference :orders, :plan, index: true
  end
end

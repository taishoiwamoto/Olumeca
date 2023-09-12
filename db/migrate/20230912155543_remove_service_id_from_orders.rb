class RemoveServiceIdFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_index :orders, :service_id
    remove_column :orders, :service_id, :integer
  end
end

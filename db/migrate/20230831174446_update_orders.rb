class UpdateOrders < ActiveRecord::Migration[7.0]
  def change
    change_column_null :orders, :buyer_id, true
    change_column_null :orders, :seller_id, true
    change_column_null :orders, :service_id, true
  end
end

class AddPersistHistoricDataFieldsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :buyer_name, :string
    add_column :orders, :seller_name, :string
    add_column :orders, :plan_title, :string
    add_column :orders, :price, :decimal
  end
end

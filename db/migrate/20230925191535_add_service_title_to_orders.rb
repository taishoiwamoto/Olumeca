class AddServiceTitleToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :service_title, :string
  end
end

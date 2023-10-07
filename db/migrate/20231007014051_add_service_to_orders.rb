class AddServiceToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :service, index: true, foregin_key: true
  end
end

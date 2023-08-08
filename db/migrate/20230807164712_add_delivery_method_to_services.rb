class AddDeliveryMethodToServices < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :delivery_method, :string
  end
end

class RemoveColumnsFromService < ActiveRecord::Migration[7.0]
  def change
    remove_column :services, :service_time, :integer
    remove_column :services, :price, :integer
    remove_column :services, :delivery_method, :string
  end
end

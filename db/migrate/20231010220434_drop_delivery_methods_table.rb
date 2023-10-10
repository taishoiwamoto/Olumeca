class DropDeliveryMethodsTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :delivery_methods
  end

  def down
    create_table :delivery_methods do |t|
      t.string "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end

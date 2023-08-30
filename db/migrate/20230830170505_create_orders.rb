class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :buyer_id
      t.integer :seller_id
      t.integer :service_id
      t.string :status

      t.timestamps
    end
  end
end

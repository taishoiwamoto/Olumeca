class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.integer :service_id
      t.string :title
      t.text :detail
      t.string :category
      t.decimal :price
      t.string :delivery_method

      t.timestamps
    end
  end
end

class RecreateCategories < ActiveRecord::Migration[7.0]
  def change
    drop_table :categories
    create_table :categories do |t|
      t.string :name
      t.timestamps
    end
    add_foreign_key :services, :categories, column: :category_id
  end
end

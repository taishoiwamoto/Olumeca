class AddColumnsToServices < ActiveRecord::Migration[7.0]
  def change
    add_column:services, :detail, :text
    add_column:services, :category, :string
    add_column:services, :hour, :integer
    add_column:services, :price, :integer
    add_column:services, :method, :string
    add_column:services, :image, :string
  end
end

class AddIndexToServices < ActiveRecord::Migration[7.0]
  def change
    add_index :services, :created_at
  end
end

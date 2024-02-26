class AddUniqueEmailAndDeletedAtIndexToUsers < ActiveRecord::Migration[7.0]
  def up
    add_index :users, [:email, :deleted_at], unique: true
  end

  def down
    remove_index :users, column: [:email, :deleted_at]
  end
end
class AddDeletionAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :deletion_at, :datetime
  end
end

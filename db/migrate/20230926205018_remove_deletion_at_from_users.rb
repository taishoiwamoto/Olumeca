class RemoveDeletionAtFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :deletion_at, :datetime
  end
end

class AddDeletionAtService < ActiveRecord::Migration[7.0]
  def change
    add_column :services, :deletion_at, :datetime
  end
end

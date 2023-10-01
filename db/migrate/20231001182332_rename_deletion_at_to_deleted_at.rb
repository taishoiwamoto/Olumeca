class RenameDeletionAtToDeletedAt < ActiveRecord::Migration[7.0]
  def change
    rename_column :plans, :deletion_at, :deleted_at
    rename_column :services, :deletion_at, :deleted_at
    rename_column :users, :deletion_at, :deleted_at
  end
end

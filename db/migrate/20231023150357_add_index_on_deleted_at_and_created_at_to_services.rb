class AddIndexOnDeletedAtAndCreatedAtToServices < ActiveRecord::Migration[7.0]
  def change
    add_index :services, [:deleted_at, :created_at]
  end
end

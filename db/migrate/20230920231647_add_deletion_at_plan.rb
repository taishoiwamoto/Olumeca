class AddDeletionAtPlan < ActiveRecord::Migration[7.0]
  def change
    add_column :plans, :deletion_at, :datetime
  end
end

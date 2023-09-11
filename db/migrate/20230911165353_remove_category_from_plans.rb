class RemoveCategoryFromPlans < ActiveRecord::Migration[7.0]
  def change
    remove_column :plans, :category, :string
  end
end

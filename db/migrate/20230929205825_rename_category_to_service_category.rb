class RenameCategoryToServiceCategory < ActiveRecord::Migration[7.0]
  def change
    rename_table :categories, :service_categories
  end
end

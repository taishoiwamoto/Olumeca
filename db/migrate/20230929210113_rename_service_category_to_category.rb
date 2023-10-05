class RenameServiceCategoryToCategory < ActiveRecord::Migration[7.0]
  def change
    rename_table :service_categories, :categories
  end
end

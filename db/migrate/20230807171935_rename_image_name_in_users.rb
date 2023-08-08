class RenameImageNameInUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :image_name, :profile_image
  end
end

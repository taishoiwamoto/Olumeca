class AddServiceIdToLikes < ActiveRecord::Migration[7.0]
  def change
    add_column :likes, :service_id, :integer
  end
end

class RemovePostIdFromLikes < ActiveRecord::Migration[7.0]
  def change
    remove_column :likes, :post_id, :integer
  end
end

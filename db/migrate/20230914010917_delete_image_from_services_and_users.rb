class DeleteImageFromServicesAndUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :image, :string
    remove_column :services, :image, :string
  end
end

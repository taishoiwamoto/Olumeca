class RemoveServiceTitleFromOrder < ActiveRecord::Migration[7.0]
  def change
  	remove_column :orders, :buyer_name , :string
  	remove_column :orders, :seller_name , :string
  	remove_column :orders, :service_title , :string
  end
end

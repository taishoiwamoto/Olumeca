class RemoveNameAndPhoneNumberFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :phone_number
    remove_column :users, :name
  end
end

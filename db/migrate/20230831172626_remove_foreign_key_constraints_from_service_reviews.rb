class RemoveForeignKeyConstraintsFromServiceReviews < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :service_reviews, :users
    remove_foreign_key :service_reviews, :services

    change_column_null :service_reviews, :user_id, true
    change_column_null :service_reviews, :service_id, true
  end
end

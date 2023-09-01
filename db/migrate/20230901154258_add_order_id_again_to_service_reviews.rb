class AddOrderIdAgainToServiceReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :service_reviews, :order_id, :integer
  end
end

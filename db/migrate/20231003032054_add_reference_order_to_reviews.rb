class AddReferenceOrderToReviews < ActiveRecord::Migration[7.0]
  def change
  	add_reference :reviews, :order, index: true, foreign_key: true
  end
end

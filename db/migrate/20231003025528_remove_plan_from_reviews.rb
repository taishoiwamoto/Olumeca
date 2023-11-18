class RemovePlanFromReviews < ActiveRecord::Migration[7.0]
  def change
  	remove_reference :reviews, :plan, index: true
  end
end

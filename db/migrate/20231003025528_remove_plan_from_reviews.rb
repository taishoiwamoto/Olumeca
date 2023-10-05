class RemovePlanFromReviews < ActiveRecord::Migration[7.0]
  def change
  	remove_reference :reviews, :plans,index: true
  end
end

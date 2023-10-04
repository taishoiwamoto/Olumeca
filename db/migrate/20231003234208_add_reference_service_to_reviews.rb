class AddReferenceServiceToReviews < ActiveRecord::Migration[7.0]
  def change
  	add_reference :reviews, :service, index: true, foreign_key: true
  end
end

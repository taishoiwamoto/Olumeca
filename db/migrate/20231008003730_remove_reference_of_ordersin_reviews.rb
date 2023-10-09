class RemoveReferenceOfOrdersinReviews < ActiveRecord::Migration[7.0]
  def change
    remove_reference :reviews, :order, index: true
  end
end

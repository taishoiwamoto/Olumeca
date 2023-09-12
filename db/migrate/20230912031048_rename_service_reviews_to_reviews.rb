class RenameServiceReviewsToReviews < ActiveRecord::Migration[7.0]
  def change
    rename_table :service_reviews, :reviews
  end
end

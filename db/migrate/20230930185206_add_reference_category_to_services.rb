class AddReferenceCategoryToServices < ActiveRecord::Migration[7.0]
  def change
  	add_reference :services, :category, index: true, foreign_key: true
  end
end

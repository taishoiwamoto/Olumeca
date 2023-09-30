class SetDefaultStatusForOrder < ActiveRecord::Migration[7.0]
  def change
    change_column_default :orders, :status, from: nil, to: 0
  end
end

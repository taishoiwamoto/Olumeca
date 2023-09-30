class ChangeStatusToIntegerInOrders < ActiveRecord::Migration[7.0]
  def up
    add_column :orders, :status_temp, :integer, default: 0

    Order.reset_column_information

    Order.all.each do |order|
      order.update_column(:status_temp, order.status.to_i)
    end

    remove_column :orders, :status
    rename_column :orders, :status_temp, :status
  end

  def down
    # 必要に応じてロールバックの方法を記述します。
  end
end

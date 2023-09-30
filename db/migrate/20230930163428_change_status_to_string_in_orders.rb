class ChangeStatusToStringInOrders < ActiveRecord::Migration[7.0]
  def up
    # 一時的に新しいカラムを作成
    add_column :orders, :status_temp, :string

    # データを新しいカラムにコピー
    Order.reset_column_information
    Order.all.each do |order|
      order.update_column(:status_temp, order.status.to_s)
    end

    # 古いカラムを削除
    remove_column :orders, :status

    # 新しいカラムの名前を変更
    rename_column :orders, :status_temp, :status
  end

  def down
    # 逆の変更をするためのコード
    add_column :orders, :status_temp, :integer, default: 0

    Order.reset_column_information
    Order.all.each do |order|
      order.update_column(:status_temp, order.status.to_i)
    end

    remove_column :orders, :status

    rename_column :orders, :status_temp, :status
  end
end

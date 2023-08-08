class RemoveMethodFromServices < ActiveRecord::Migration[7.0]
  def change
    remove_column :services, :method, :string  # :stringはカラムのデータ型を指します。元のカラムのデータ型と一致している必要があります。
  end
end

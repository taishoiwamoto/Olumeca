class CreateServiceReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :service_reviews do |t|
      t.references :user, foreign_key: true # 評価者
      t.references :service, foreign_key: true # 評価対象のサービス
      t.integer :rating # 評価のスコア
      t.text :comment # コメント

      t.timestamps
    end
  end
end

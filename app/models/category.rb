class Category < ApplicationRecord
  # このカテゴリーに属するサービスとの関連付けを定義します。
  # `has_many :services`は、一つのカテゴリーが複数のサービスを持つことができることを示します。
  # `dependent: :nullify`オプションは、このカテゴリーが削除された時に、
  # それに属するサービスの`category_id`を`NULL`にすることを指定します。
  # これにより、カテゴリーが削除されてもサービスはデータベースに残りますが、どのカテゴリーにも属さなくなります。
	has_many :services, dependent: :nullify

  # カテゴリーの名前が必ず存在することをバリデーションで確認します。
  # `validates :name, presence: true`は、`name`フィールドが空でないことを保証します。
  # このバリデーションにより、名前無しのカテゴリーの作成を防ぎます。
  validates :name, presence: true
end

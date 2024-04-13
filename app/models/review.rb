# ユーザーによるサービスへの評価とフィードバックを管理するモデルです。

class Review < ApplicationRecord
  # レビューは特定のユーザーに属します。これにより、どのユーザーがこのレビューを作成したかを識別できます。
  belongs_to :user

  # レビューは特定のサービスに関連付けられています。これにより、どのサービスがレビューされたかを識別できます。
  belongs_to :service

  # レーティングは必須で、整数である必要があります。また、その値は1から5の間でなければなりません。
  # このバリデーションは、レビューに対する評価が適切な範囲内であることを保証します。
  validates :rating, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5
  }

  # 同一のユーザーが同一のサービスに対して複数のレビューを投稿することを防ぐためのバリデーションです。
  # user_idとservice_idの組み合わせは重複できず、もし既に同じサービスにレビューが存在する場合は、
  # エラーメッセージとして "has already reviewed this service" をユーザーに提示します。
  validates :user_id, uniqueness: { scope: :service_id, message: "has already reviewed this service" }
end

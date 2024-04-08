class Review < ApplicationRecord
  # レビューが特定のユーザーとサービスに属していることを示す関連付け。
  belongs_to :user
  belongs_to :service

  # レビューの評価(rating)が必ず存在し、整数であり、1から5の間であることを保証するバリデーション。
  validates :rating, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5
  }

  # 同一のユーザーが同一のサービスに対して複数回レビューを投稿することを防ぐためのバリデーション。
  # user_idとservice_idの組み合わせがユニークであることを要求します。
  # もし既にレビューが存在する場合は、「has already reviewed this service」というメッセージを表示します。
  validates :user_id, uniqueness: { scope: :service_id, message: "has already reviewed this service" }
end

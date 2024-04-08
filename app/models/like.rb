class Like < ApplicationRecord
  # この「いいね」が特定のユーザーとサービスに属していることを示す関連付け。
  belongs_to :user
  belongs_to :service

  # ユーザーIDとサービスIDの存在を保証するバリデーション。
  # これにより、どのユーザーがどのサービスを「いいね」したかを追跡できます。
  validates :user_id, :service_id, presence: true

  # 特定のユーザーIDとサービスIDの組み合わせに対する「いいね」が存在するかどうかをチェックするクラスメソッド。
  def self.user_and_service(user_id, service_id)
    # find_byメソッドを使って、指定されたユーザーIDとサービスIDの組み合わせで「いいね」を検索。
    # 存在すればtrueを返し、存在しなければfalseを返します。
    return true if find_by(user_id:, service_id:).present?

    false
  end
end

# ユーザーがサービスに対して「いいね！」を行うためのモデルです。各「いいね！」は特定のユーザーとサービスに関連付けられます。
class Like < ApplicationRecord
  # 「いいね！」は特定のユーザーに属します。これはUserモデルとの関連付けを示しており、
  # 各いいねレコードが一人のユーザーに紐付いていることを表します。
  belongs_to :user

  # 「いいね！」は特定のサービスに属します。これはServiceモデルとの関連付けを示しており、
  # 各いいねレコードが一つのサービスに紐付いていることを表します。
  belongs_to :service

  # ユーザーIDとサービスIDはどちらも必須です。
  validates :user_id, :service_id, presence: true

  # 特定のユーザーが特定のサービスに対して「いいね！」をすでに行っているかどうかを確認するクラスメソッドです。
  # ユーザーIDとサービスIDを受け取り、対応する「いいね！」が存在すればtrueを、存在しなければfalseを返します。
  def self.user_and_service(user_id, service_id)
    return true if find_by(user_id:, service_id:).present?

    false
  end
end

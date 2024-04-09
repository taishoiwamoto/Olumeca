class Order < ApplicationRecord
  # 購入者と売り手をUserモデルに関連付けます。これは自己参照関連ですが、役割(role)に基づいて区別されます。
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  # サービスとの関連付け。
  belongs_to :service
  # オーダーのステータスをenumで定義します。可能な値は'pending', 'accepted', 'rejected'です。
  enum status: ['pending', 'accepted', 'rejected']

  # 特定のユーザーがこのオーダーに関連するサービスをレビューしたかどうかを確認するインスタンスメソッド。
  def service_reviewed_by_user?(user_id)
    Review.find_by(user_id: user_id, service: service).present?
  end

  # 特定のユーザーによるこのオーダーに関連するサービスのレビューIDを取得するインスタンスメソッド。
  def review_by_user(user_id)
    Review.find_by(user_id: user_id, service: service)&.id
  end

  # 特定のユーザーが特定のサービスをレビューしたかどうかを確認するクラスメソッド。
  def self.service_reviewed_by_user?(user_id, service_id)
    Review.exists?(user_id: user_id, service_id: service_id)
  end

  # 特定のユーザーによる特定のサービスのレビューIDを取得するクラスメソッド。
  def self.review_id_by_user(user_id, service_id)
    Review.find_by(user_id: user_id, service_id: service_id)&.id
  end
end

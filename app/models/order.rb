# 注文情報を管理するモデルで、各注文は買い手（buyer）、売り手（seller）、およびサービスに関連付けられます。
class Order < ApplicationRecord
  # 注文は特定の買い手（Userモデルのインスタンス）に属します。
  # buyer_idを外部キーとして使用し、Userモデルにリンクされます。
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'

  # 注文は特定の売り手（Userモデルのインスタンス）に属します。
  # seller_idを外部キーとして使用し、Userモデルにリンクされます。
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'


  # 注文は特定のサービスに関連付けられます。
  # これにより、注文された具体的なサービスの詳細を追跡できます。
  belongs_to :service

  # 注文のステータスを列挙型で定義します。ステータスは「pending（保留中）」、「accepted（承認済み）」、「rejected（拒否）」のいずれかです。
  # enumは、特定のフィールドに対して事前定義された固定の値を割り当てる機能です。
  # enumを使うことで、状態管理や条件分岐をシンプルに記述することが可能です。
  enum status: ['pending', 'accepted', 'rejected']

  # インスタンスメソッド (service_reviewed_by_user?, review_by_user): 
  # これらは特定のOrderインスタンスに対して呼び出されるため、serviceオブジェクトはその注文インスタンスから直接取得されます。
  # これにより、特定の注文に関連するサービスのレビュー状況やレビューIDを取得するのに使用されます。
  # 前者は注文に紐づいたサービスに対して、後者は任意のサービスIDに基づいて確認します。

  # 特定のユーザーがこの注文に関連するサービスをレビューしたかどうかを確認します。
  # レビューが存在すればtrue、存在しなければfalseを返します。
  def service_reviewed_by_user?(user_id)
    Review.find_by(user_id: user_id, service: service).present?
  end

  # 特定のユーザーによるこの注文のサービスに対するレビューのIDを取得します。
  # レビューが存在すればそのIDを、存在しなければnilを返します。
  def review_by_user(user_id)
    Review.find_by(user_id: user_id, service: service)&.id
  end

  # クラスメソッド (self.service_reviewed_by_user?, self.review_id_by_user): 
  # これらはOrderクラス全体に対して呼び出され、ユーザーIDとサービスIDを引数として直接受け取ります。
  # これにより、特定の注文のコンテキストを超えて任意のサービスに対するレビューの有無やそのIDを調べることができます。
  # 前者は注文に紐づいたサービスに対して、後者は特定のサービスIDに基づいてIDを検索します。

  # 特定のユーザーが特定のサービスをレビューしたかどうかを確認します。
  # レビューが存在すればtrue、存在しなければfalseを返します。
  def self.service_reviewed_by_user?(user_id, service_id)
    Review.exists?(user_id: user_id, service_id: service_id)
  end


  # 特定のユーザーによる特定のサービスに対するレビューのIDを取得します。
  # レビューが存在すればそのIDを、存在しなければnilを返します。
  def self.review_id_by_user(user_id, service_id)
    Review.find_by(user_id: user_id, service_id: service_id)&.id
  end
end

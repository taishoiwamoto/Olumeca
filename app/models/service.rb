class Service < ApplicationRecord
  # キーワードによる検索を行うためのスコープ。アクティブなサービスの中から、タイトルまたは詳細にキーワードが含まれるものを検索します。
  scope :by_keyword, ->(keyword) { active.where("title LIKE ? OR detail LIKE ?", "%#{keyword}%", "%#{keyword}%") }

  # このサービスが特定のユーザーに属していること、カテゴリーに属していること、および関連する注文、レビュー、いいねを持つことを示す関連付け。
  belongs_to :user
  has_many :orders
  belongs_to :category
  has_many :reviews
  has_many :likes, dependent: :destroy
  # サービスに画像を添付できるようにするための宣言。
  has_one_attached :image

  # サービスのタイトルが必ず存在し、最大100文字であることを保証するバリデーション。
  validates :title,
    presence: true,
    length: {
      maximum: 100,
      too_long: ':El nombre del servicio debe tener menos de %{count} caracteres.'
    }
  # サービスの詳細が必ず存在することを保証するバリデーション。
  validates :detail, presence: true

  # アクティブなサービス（deleted_atがnilのもの）だけを取得するためのスコープ。
  scope :active, -> { where(deleted_at: nil) }

  # サービスをソフトデリート（論理削除）するためのメソッド。deleted_atに現在時刻を設定します。
  def soft_delete
    update_attribute(:deleted_at, Time.now)
  end

  # サービスに対するレビューの平均評価を計算するメソッド。
  def average_rating
    reviews.average(:rating).to_f.round(2)
  end

  # サービスに対する「いいね」の数をカウントするメソッド。
  def count_likes
    likes.length
  end

  # サービスがソフトデリートされているかどうかを確認するメソッド。
  def deleted?
    deleted_at.present?
  end
end

class User < ApplicationRecord
  # Deviseの認証モジュールを設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  # ユーザー作成時に利用規約の同意が必要
  validates_acceptance_of :agreement, allow_nil: false, on: :create

  # パスワードの存在、確認、長さに関するバリデーション
  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: 6..128, allow_blank: true

  # ユーザーに関連するサービス、注文、レビュー、いいね、および画像の関連付け
  has_many :services, dependent: :nullify
  has_many :purchased_orders, class_name: 'Order', foreign_key: 'buyer_id', dependent: :nullify
  has_many :sold_orders, class_name: 'Order', foreign_key: 'seller_id', dependent: :nullify
  has_many :reviews, dependent: :nullify
  has_many :likes, dependent: :destroy
  has_one_attached :image

  # 名前と電話番号の存在と長さに関するバリデーション
  validates :name,
    presence: true,
    length: {
    maximum: 30,
    too_long: ':El nombre del usuario debe tener menos de %{count} caracteres.'
  }
  validates :phone_number, presence: true

   # アクティブなアカウントにおけるメールの一意性を確認するカスタムバリデーション
  validate :email_uniqueness_for_inactive_accounts, on: :create

  # アクティブなユーザー（deleted_atがnilのもの）だけを取得するスコープ
  scope :active, -> { where(deleted_at: nil) }

  # アクティブなアカウントにおいてメールアドレスが一意であることを保証するカスタムバリデーションメソッド
  def email_uniqueness_for_inactive_accounts
    if User.where(email: email, deleted_at: nil).exists?
      errors.add(:email, "ya esta en uso")
    end
  end

  # 認証時にアクティブなユーザーのみを考慮する
  def self.find_for_authentication(conditions)
    conditions[:deleted_at] = nil # 削除されていないユーザーのみを対象とします
    find_by(conditions)
  end

  # ユーザーが提供するサービスに対するレビューの平均評価を計算
  def average_service_rating
    reviews = Review.joins(service: :user).where(services: { user_id: id })
    reviews.average(:rating).to_f
  end

  # ユーザーに対する全レビューの平均評価を計算
  def average_rating
    reviews.average(:rating).to_f
  end

  # ユーザーをソフトデリートし、関連するサービスもソフトデリートする
  def soft_delete
    update_attribute(:deleted_at, Time.now)
    services.each(&:soft_delete)
  end

  # Devise認証において、ユーザーがアクティブであるかどうかを判断
  def active_for_authentication?
    super && !deleted_at
  end

  # アクティブでないユーザーに関するメッセージをカスタマイズ
  def inactive_message
    !deleted_at ? super : :not_found_in_database
  end

  # ユーザーが更新された後に条件を満たす場合、関連する保留中の注文を拒否する
  after_update :reject_pending_orders, if: -> { saved_change_to_attribute?(:deleted_at) && !deleted_at.nil? }

  # ユーザーがソフトデリートされているかどうかを確認するメソッド。
  def deleted?
    deleted_at.present?
  end

  # ユーザー情報を「削除済み」として更新し、個人情報を削除する
  def hard_delete
    update(name: "Dado de baja", email: "--", phone_number: "--")
    save
  end

  #プライベートメソッドは、そのクラスの外部からは直接呼び出すことができず、クラス内部からのみアクセス可能です。
  private

  # ユーザーが削除された際に、保留中の注文を拒否する
  def reject_pending_orders
    Order.where(buyer_id: id, status: :pending).or(Order.where(seller_id: id, status: :pending)).each do |order|
      order.update(status: :rejected)
    end
  end

  # 指定されたメールアドレスが既に取られているかどうかを確認するクラスメソッド
  def self.email_taken?(email)
    !where(email: email, deleted_at: nil).empty?
  end

  # パスワードが必要かどうかを判断するメソッド。新規作成またはパスワード変更時には必要
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end

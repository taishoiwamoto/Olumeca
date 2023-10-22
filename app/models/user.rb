class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  validates_acceptance_of :agreement, allow_nil: false, on: :create

  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: 6..128, allow_blank: true

  has_many :services, dependent: :nullify
  has_many :purchased_orders, class_name: 'Order', foreign_key: 'buyer_id', dependent: :nullify
  has_many :sold_orders, class_name: 'Order', foreign_key: 'seller_id', dependent: :nullify
  has_many :reviews, dependent: :nullify
  has_many :likes, dependent: :destroy
  has_one_attached :image


  validates :name,
    presence: true,
    length: {
    maximum: 30,
    too_long: ':El nombre del usuario debe tener menos de %{count} caracteres.'
  }

  validates :phone_number, presence: true
  validate :email_uniqueness_for_inactive_accounts, on: :create

  scope :active, -> { where(deleted_at: nil) }

  def email_uniqueness_for_inactive_accounts
    if User.where(email: email, deleted_at: nil).exists?
      errors.add(:email, "ya esta en uso")
    end
  end

  def self.find_for_authentication(conditions)
    conditions[:deleted_at] = nil # Only consider active users
    find_by(conditions)
  end

  def average_service_rating
    #完了 [重要度: 低] https://railsdoc.com/page/average active recordのaverageの利用を検討してください。
    reviews = Review.joins(service: :user).where(services: { user_id: id })
    reviews.average(:rating).to_f
  end

  def average_rating
    #完了 [重要度: 低] https://railsdoc.com/page/average active recordのaverageの利用を検討してください。
    reviews.average(:rating).to_f
  end

  def soft_delete
    #完了 [重要度: 高] 退会後に個人情報を削除しないと問題になる可能性があります → methodのhard_deleteで上書きする
    # 一方で、即日削除も、ユーザが不適切な行為を行った場合の責任追及ができないなど問題が生じます。
    # 適切な期間を置いた後で完全に情報が削除できるような検討をしてください。
    # 物理削除をすると他の問題が出てきますので、通常、適当な値で上書きをしてあげるという処置をします。
    update_attribute(:deleted_at, Time.now)
    services.each(&:soft_delete)
  end

  def active_for_authentication?
    super && !deleted_at
  end

  def inactive_message
    !deleted_at ? super : :not_found_in_database
  end

  after_update :reject_pending_orders, if: -> { saved_change_to_attribute?(:deleted_at) && !deleted_at.nil? }

  def deleted?
    deleted_at.present?
  end

  def hard_delete
    update(name: "Dado de baja", email: "--", phone_number: "--")
    save
  end

  private

  def reject_pending_orders
    Order.where(buyer_id: id, status: :pending).or(Order.where(seller_id: id, status: :pending)).each do |order|
      order.update(status: :rejected)
    end
  end

  def self.email_taken?(email)
    !where(email: email, deleted_at: nil).empty?
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end

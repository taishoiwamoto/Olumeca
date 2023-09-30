class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates_acceptance_of :agreement, allow_nil: false, on: :create
  has_many :services, dependent: :destroy
  has_many :plans, through: :services
  has_many :purchased_orders, class_name: 'Order', foreign_key: 'buyer_id', dependent: :nullify
  has_many :sold_orders, class_name: 'Order', foreign_key: 'seller_id', dependent: :nullify
  has_many :reviews, dependent: :nullify
  has_many :sold_reviews, through: :sold_orders, source: :review
  has_many :likes, dependent: :destroy
  has_one_attached :image


  validates :name,
    presence: true,
    length: {
    maximum: 30,
    too_long: ':El nombre del usuario debe tener menos de %{count} caracteres.'
  }

  validates :phone_number, presence: true

  scope :active, -> { where(deletion_at: nil) }

  def average_service_rating
    sold_reviews.average(:rating)
  end

  def soft_delete
    update_attribute(:deletion_at, Time.now)
    services.each(&:soft_delete)
  end

  def active_for_authentication?
    super && !deletion_at
  end

  def inactive_message
    !deletion_at ? super : :deleted_account
  end

  after_update :reject_pending_orders, if: -> { saved_change_to_attribute?(:deletion_at) && !deletion_at.nil? }

  private

  def reject_pending_orders
    Order.where(buyer_id: id, status: :pending).or(Order.where(seller_id: id, status: :pending)).each do |order|
      order.update(status: :rejected)
    end
  end
end

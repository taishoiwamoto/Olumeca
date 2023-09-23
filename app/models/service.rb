class Service < ApplicationRecord
  belongs_to :user

  has_many :plans, dependent: :destroy, foreign_key: "service_id", inverse_of: :service, autosave: true
  has_many :reviews, through: :plans
  #has_many :reviews, dependent: :nullify
  #has_many :indirect_reviews, through: :plans, source: :reviews
  #has_many :direct_reviews, class_name: 'Review', dependent: :nullify
  has_many :likes, dependent: :destroy
  has_one_attached :image

  accepts_nested_attributes_for :plans, allow_destroy: true, reject_if: :all_blank

  validates :title,
    presence: true,
    length: {
      maximum: 65,
      too_long: ':El nombre del servicio debe tener menos de %{count} caracteres.'
    }
  validates :category, presence: true
  validates :detail, presence: true
  validate :plans_present?
  validates_associated :plans

  def update_plans(plans_params)
    self.plans.delete_all

    plans_params.each do |plan_param|
      title = plan_param[1]['title']
      detail = plan_param[1]['detail']
      price = plan_param[1]['price']
      delivery_method = plan_param[1]['delivery_method']

      new_plan = self.plans.new(title: title, detail: detail, price: price, delivery_method: delivery_method)

      new_plan.save
    end
  end

  private

  def plans_present?
    return if plans.present?

    errors.add(:plans, "El servicio debe tener al menos un plan.")
  end
end

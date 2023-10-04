class Service < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :plans, dependent: :destroy, foreign_key: "service_id", inverse_of: :service, autosave: true
  # has_many :reviews, through: :plans
  has_many :reviews
  has_many :likes, dependent: :destroy
  has_one_attached :image

  accepts_nested_attributes_for :plans, allow_destroy: true, reject_if: :all_blank

  validates :title,
    presence: true,
    length: {
      maximum: 65,
      too_long: ':El nombre del servicio debe tener menos de %{count} caracteres.'
    }
  validates :detail, presence: true
  validate :plans_present?
  validates_associated :plans

  scope :active, -> { where(deleted_at: nil) }

  scope :active, -> { where(deleted_at: nil) }

  def update_plans(plans_params)
    puts 'planes'
    puts plans_params.count
    puts plans_params
    updated_plan_ids = []
  
    plans_params.each_pair do |_, plan_param|
      id = plan_param['id']
      title = plan_param['title']
      detail = plan_param['detail']
      price = plan_param['price']
      delivery_method = plan_param['delivery_method']
  
      existing_plan = self.plans.find_by(id: id)
  
      if existing_plan
        existing_plan.update(
          title: title,
          detail: detail,
          price: price,
          delivery_method: delivery_method
        )
        updated_plan_ids << existing_plan.id
      else
        new_plan = self.plans.create(
          title: title,
          detail: detail,
          price: price,
          delivery_method: delivery_method
        )
        updated_plan_ids << new_plan.id
      end
    end
    self.plans.where.not(id: updated_plan_ids).destroy_all
  end

  def soft_delete
    update_attribute(:deleted_at, Time.now)

    plans.each(&:soft_delete)
  end

  private

  def plans_present?
    return if plans.present?

    errors.add(:plans, "El servicio debe tener al menos un plan.")
  end
end

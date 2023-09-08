class UsersController < ApplicationController
  before_action :authenticate_user, except: %i[show]
  #before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}

  def show
    @services = current_user.services.order(created_at: :desc).page(params[:page]).per(5)

    total_reviews = 0
    total_count = 0

    current_user.services.each do |service|
      total_reviews += service.service_reviews.sum(:rating)
      total_count += service.service_reviews.count
    end

    @average_rating = total_count > 0 ? total_reviews / total_count.to_f : nil
  end

  def likes
    @likes = Like.where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(5)

    total_reviews = 0
    total_count = 0

    current_user.services.each do |service|
      total_reviews += service.service_reviews.sum(:rating)
      total_count += service.service_reviews.count
    end

    @average_rating = total_count > 0 ? total_reviews / total_count.to_f : nil
  end


  def orders
    @orders = Order.where(buyer_id: current_user.id).order(created_at: :desc).page(params[:page]).per(5)

    total_reviews = 0
    total_count = 0

    current_user.services.each do |service|
      total_reviews += service.service_reviews.sum(:rating)
      total_count += service.service_reviews.count
    end

    @average_rating = total_count > 0 ? total_reviews / total_count.to_f : nil
  end

  def sales
    @sales = Order.where(seller_id: current_user.id).order(created_at: :desc).page(params[:page]).per(5)

    total_reviews = 0
    total_count = 0

    current_user.services.each do |service|
      total_reviews += service.service_reviews.sum(:rating)
      total_count += service.service_reviews.count
    end

    @average_rating = total_count > 0 ? total_reviews / total_count.to_f : nil
  end

  private

end

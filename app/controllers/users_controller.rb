class UsersController < ApplicationController
  before_action :authenticate_user, except: [:show, :reviews]
  before_action :set_user, only: [:likes, :orders, :sales, :reviews]
  before_action :find_active_user, only: [:show, :reviews]

  def show
    @services = @user.services.active.order(created_at: :desc).page(params[:page]).per(5)
    @average_rating = @user.average_service_rating
  end

  def reviews
    order_ids = Order.where(seller_id: @user.id).pluck(:id)
    @reviews = Review.where(order_id: order_ids).order(created_at: :desc).page(params[:page]).per(5)
  end

  def likes
    set_services_and_rating_for
    @likes = Like.joins(:service).merge(Service.active).where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(5)
  end

  def orders
    set_services_and_rating_for
    @orders = Order.where(buyer_id: current_user.id).order(created_at: :desc).page(params[:page]).per(5)
  end

  def sales
    set_services_and_rating_for
    @sales = Order.where(seller_id: current_user.id).order(created_at: :desc).page(params[:page]).per(5)
  end

  def destroy
    user_id = params[:id]
    @user = User.find(user_id)
    @user.soft_delete
  end

  private

  def set_user
    @user = current_user
  end

  def set_services_and_rating_for
    total_reviews = 0
    total_count = 0

    @user.services.each do |service|
      service.plans.each do |plan|
        total_reviews += plan.reviews.sum(:rating)
        total_count += plan.reviews.count
      end
    end

    @average_rating = total_count > 0 ? total_reviews / total_count.to_f : nil
  end

  def find_active_user
    @user = User.active.find_by(id: params[:id])

    if @user.nil?
      render file: "#{Rails.root}/public/404.html"
    end
  end
end

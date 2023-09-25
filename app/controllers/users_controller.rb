class UsersController < ApplicationController
  before_action :authenticate_user, except: [:show, :reviews]
  before_action :set_user, only: [:likes, :orders, :sales, :reviews]

  def show
    @user = User.find(params[:id])
    @services = @user.services.order(created_at: :desc).page(params[:page]).per(5)
    @average_rating = @user.average_service_rating
    @total_reviews_count = Review.joins(plan: :service).where(services: { user_id: @user.id }).count
  end

  def reviews
    @user = User.find(params[:id])
    order_ids = Order.where(seller_id: @user.id).pluck(:id)
    @reviews = Review.where(order_id: order_ids).order(created_at: :desc).page(params[:page]).per(5)
    @total_reviews_count = Review.joins(plan: :service).where(services: { user_id: @user.id }).count
  end

  def likes
    set_services_and_rating_for
    @likes = Like.where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(5)
    @total_reviews_count = Review.joins(plan: :service).where(services: { user_id: @user.id }).count
  end


  def orders
    set_services_and_rating_for
    @orders = Order.where(buyer_id: current_user.id).order(created_at: :desc).page(params[:page]).per(5)
    @total_reviews_count = Review.joins(plan: :service).where(services: { user_id: @user.id }).count
  end

  def sales
    set_services_and_rating_for
    @sales = Order.where(seller_id: current_user.id).order(created_at: :desc).page(params[:page]).per(5)
    @total_reviews_count = Review.joins(plan: :service).where(services: { user_id: @user.id }).count
  end

  def destroy
    user_id = params[:id]
    @user = User.find(user_id)
    @user.deletion_at = DateTime.now
    @user.save
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
end

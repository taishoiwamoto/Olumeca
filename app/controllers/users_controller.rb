class UsersController < ApplicationController
  before_action :authenticate_user, except: %i[show]
  before_action :set_user, only: [:likes, :orders, :sales]
  #before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}

  def show
    @user = User.find(params[:id])
    @services = @user.services.order(created_at: :desc).page(params[:page]).per(5)
    @average_rating = @user.average_service_rating
  end

  def likes
    set_services_and_rating_for(@user)
    @likes = Like.where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(5)
  end


  def orders
    set_services_and_rating_for(@user)
    @orders = Order.where(buyer_id: current_user.id).order(created_at: :desc).page(params[:page]).per(5)
  end

  def sales
    set_services_and_rating_for(@user)
    @sales = Order.where(seller_id: current_user.id).order(created_at: :desc).page(params[:page]).per(5)
  end

  private

  def set_user
    @user = current_user
  end

  def set_services_and_rating_for(user)
    total_reviews = 0
    total_count = 0

    user.services.each do |service|
      service.plans.each do |plan|
        total_reviews += plan.reviews.sum(:rating)
        total_count += plan.reviews.count
      end
    end

    @average_rating = total_count > 0 ? total_reviews / total_count.to_f : nil
  end
end

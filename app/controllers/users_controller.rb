class UsersController < ApplicationController
  before_action :authenticate_user, except: [:show, :reviews]
  before_action :set_user, only: %i[show likes orders sales reviews destroy]

  def show
    @services = @user.services.active.order(created_at: :desc).page(params[:page]).per(5)
    @average_rating = @user.average_service_rating
  end

  def reviews
    service_ids = Service.where(user_id: @user.id).pluck(:id)
    @reviews = Review.where(service_id: service_ids).order(created_at: :desc).page(params[:page]).per(5)
  end

  def likes
    # set_services_and_rating_for
    @likes = Like.joins(:service).merge(Service.active).where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(5)
  end

  def orders
    # set_services_and_rating_for
    @orders = Order.where(buyer_id: current_user.id).order(created_at: :desc).page(params[:page]).per(5)
  end

  def sales
    # set_services_and_rating_for
    @sales = Order.where(seller_id: current_user.id).order(created_at: :desc).page(params[:page]).per(5)
  end

  def destroy
    @user.soft_delete
  end

  private

  # def set_services_and_rating_for
  #   @average_rating = 0 # total_count > 0 ? total_reviews / total_count.to_f : nil
  # end

  def set_user
    @user = User.active.find(params[:id])
  end
end

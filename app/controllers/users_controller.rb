class UsersController < ApplicationController
  before_action :authenticate_user, except: [:show]
  before_action :find_active_user, only: %i[show likes orders sales]

  def show
    @services = @user.services.active.order(created_at: :desc).page(params[:page]).per(5)
    @average_rating = @user.average_service_rating

    # 以下のコードを追加して@reviewsをセットしてください
    service_ids = @user.services.pluck(:id)
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
    user_id = params[:id]
    @user = User.find(user_id)
    @user.soft_delete
  end

  private

  # def set_services_and_rating_for
  #   @average_rating = 0 # total_count > 0 ? total_reviews / total_count.to_f : nil
  # end

  def find_active_user
    @user = User.active.find_by(id: params[:id])

    render file: "#{Rails.root}/public/404.html" if @user.nil?

    if @user.nil?
      render file: "#{Rails.root}/public/404.html"
    else
      @user = User.active.find(params[:id])
    end
  end

  def set_user
    @user = User.active.find(params[:id])
  end
end

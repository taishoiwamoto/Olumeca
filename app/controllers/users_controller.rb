class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:edit, :update, :orders, :sales]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy, :likes, :orders, :sales]}

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    @services = current_user.services.order(created_at: :desc).page(params[:page]).per(5)

    total_reviews = 0
    total_count = 0

    current_user.services.each do |service|
      total_reviews += service.service_reviews.sum(:rating)
      total_count += service.service_reviews.count
    end

    @average_rating = total_count > 0 ? total_reviews / total_count.to_f : nil
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      profile_image: "default_user.jpg",
      password: params[:password]
    )
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Se ha completado el registro de usuario"
      redirect_to("/users/#{@user.id}")
    else
      render("users/new")
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    @user.password = params[:password]

    if params[:image]
      @user.profile_image = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.profile_image}", image.read)
    end

    if @user.save
      flash[:notice] = "Has editado la información del usuario"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    flash[:notice] = "Has eliminado su cuenta"
    redirect_to("/login")
  end

  def login_form
    flash[:alert] = params[:flash_alert] if params[:flash_alert].present?
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "Has iniciado sesión"
      redirect_to("/services/index")
    else
      @error_message = "El correo electrónico o la contraseña son incorrectos"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Has cerrado sesión"
    redirect_to("/users/sign_in")
  end

  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id).order(created_at: :desc).page(params[:page]).per(5)

    total_reviews = 0
    total_count = 0

    @user.services.each do |service|
      total_reviews += service.service_reviews.sum(:rating)
      total_count += service.service_reviews.count
    end

    @average_rating = total_count > 0 ? total_reviews / total_count.to_f : nil
  end


  def orders
    @user = User.find_by(id: params[:id])  # この行を修正
    @orders = Order.where(buyer_id: @user.id).order(created_at: :desc).page(params[:page]).per(5)

    total_reviews = 0
    total_count = 0

    @user.services.each do |service|
      total_reviews += service.service_reviews.sum(:rating)
      total_count += service.service_reviews.count
    end

    @average_rating = total_count > 0 ? total_reviews / total_count.to_f : nil
  end

  def sales
    @user = User.find(params[:id])
    @sales = Order.where(seller_id: @user.id).order(created_at: :desc).page(params[:page]).per(5)

    total_reviews = 0
    total_count = 0

    @user.services.each do |service|
      total_reviews += service.service_reviews.sum(:rating)
      total_count += service.service_reviews.count
    end

    @average_rating = total_count > 0 ? total_reviews / total_count.to_f : nil
  end

  def ensure_correct_user
    if current_user.id != params[:id].to_i
      flash[:notice] = "No tienes autorización"
      redirect_to("/")
    end
  end

end

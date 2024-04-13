# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # 新規登録時に特定のパラメータを許可するための設定
  before_action :configure_sign_up_params, only: [:create]
  # アカウント更新時に特定のパラメータを許可するための設定
  before_action :configure_account_update_params, only: [:update]
  # 新規登録時にメールアドレスの重複チェックを行う
  before_action :check_email_uniqueness, only: [:create]

  # DELETE /resource
  # ユーザーのアカウントを論理削除し、セッションを終了させる
  def destroy
    resource.soft_delete

    sign_out resource
    redirect_to root_path, notice: 'La cuenta de usuario fue cancelada'
  end

  # protected キーワードによって定義されたメソッドは、同じクラスまたはそのサブクラスのインスタンスからのみアクセス可能です。
  # これは、クラス外部からは直接呼び出すことができないことを意味します。
  protected

  # アカウント更新後のリダイレクト先
  def after_update_path_for(resource)
    user_path(current_user)
  end

  # サインアップ時に追加で許可するパラメータを設定
  #def configure_sign_up_params
  #  devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number, :image])
  #end

  # アカウント更新時に追加で許可するパラメータを設定
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone_number, :image])
  end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   redirect_to root
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # 許可する追加のパラメータがある場合は、サニタイザーに追加する。
  def configure_sign_up_params
    # :sign_up は、Devise で使用されるアクション
    devise_parameter_sanitizer.permit(:sign_up, keys: [:agreement, :name, :phone_number, :email, :password, :password_confirmation])
  end

  # メールアドレスの重複チェックを行うメソッド
  def check_email_uniqueness
    if User.email_taken?(params[:user][:email])
      existing_user = User.find_by(email: params[:user][:email])
      if existing_user.deleted_at.nil?
        # Email is in use by an active account
        # アクティブなアカウントでメールアドレスが使用されている場合
        flash[:error] = "This email is already registered. If you forgot your password, you can reset it."
      else
        # Email is in use by an inactive account, allow the registration.
        # 非アクティブなアカウントでメールアドレスが使用されている場合、登録を許可
        bypass_sign_in(existing_user) # Deviseのサインインをバイパス
        existing_user.update(deleted_at: nil) # 既存のユーザーをアクティブにする
        redirect_to new_user_session_path
      end
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

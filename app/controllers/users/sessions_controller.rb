# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # サインイン作成時のアクションをオーバーライド
  def create
    if verify_recaptcha
      #redirect_to root_path
      # reCAPTCHA認証が成功した場合、Deviseのデフォルトのサインイン処理を実行
      super
      #render :edit
    else
      # reCAPTCHA認証が失敗した場合、サインインページにリダイレクトしエラーメッセージを表示
      self.resource = resource_class.new(sign_in_params)
      flash.now[:alert] = 'Recaptcha verification failed'
      render :new
    end
  end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end

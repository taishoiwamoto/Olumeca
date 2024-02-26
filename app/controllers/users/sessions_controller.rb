# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def create
    if verify_recaptcha
      super
    else
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

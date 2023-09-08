class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  FQDN = ENV["ALLOWED_HOST"]
  ALLOWED_HOSTS = [ENV["ALLOWED_HOST"], ENV["ALLOWED_OLD_HOST"]]
  before_action :ensure_domain
  before_action :set_current_user
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_current_user
    current_user = User.find_by(id: session[:user_id])
  end

  def authenticate_user
    if current_user == nil
      flash[:notice] = "Es necesario iniciar sesión"
      redirect_to("/users/sign_in")
    end
  end

  def forbid_login_user
    if current_user
      flash[:notice] = "Ya has iniciado sesión"
      redirect_to("/services/index")
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number, :profile_image])
  end
  def ensure_domain
    return unless /\.herokuapp.com/ =~ request.host

    port = ":#{request.port}" unless [80, 443].include?(request.port)
    redirect_url = "#{request.protocol}#{FQDN}#{port}#{request.path}"
    redirect_host = URI.parse(redirect_url).host

    if ALLOWED_HOSTS.include?(redirect_host)
      redirect_to redirect_url, status: :moved_permanently, allow_other_host: true
    else
      render plain: 'Not Allowed', status: :forbidden
    end
  end
end

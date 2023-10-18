class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  FQDN = ENV["ALLOWED_HOST"]
  ALLOWED_HOSTS = [ENV["ALLOWED_HOST"], ENV["ALLOWED_OLD_HOST"]]
  before_action :ensure_domain
  before_action :configure_permitted_parameters, if: :devise_controller?

  def authenticate_user
    unless user_signed_in?
      flash[:notice] = "Es necesario iniciar sesión"
      redirect_to new_user_session_path
    end
  end

  def forbid_login_user
    if current_user
      flash[:notice] = "Ya has iniciado sesión"
      redirect_to services_path
    end
  end

  protected

  def configure_permitted_parameters
    #devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number, :profile_image])
  end

  def ensure_domain
    # [重要度⭐️: 低] アクセスの制限を一部でしていると思いますが、本来的にはこのような処理はインフラレイヤーで行うべきです。
    # 不要なアクセスをRailsで受けることになるため、不要なサーバーリソースを使うことになるためです。また実装不備によりこの処理が通らなかったときに重要な不具合となる可能性を秘めます。
    # Herokuでどこまで行えるかという問題もありますので、重要度を低としています。
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

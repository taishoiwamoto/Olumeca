class ApplicationController < ActionController::Base
  # CSRF攻撃防止用のセキュリティ機能を有効化
  protect_from_forgery with: :exception

  # 環境変数から許可されたホスト名を取得し、定数に格納
  FQDN = ENV["ALLOWED_HOST"]

  # 許可されたホストのリストを環境変数から設定
  ALLOWED_HOSTS = [ENV["ALLOWED_HOST"], ENV["ALLOWED_OLD_HOST"]]

  # アクション前にドメインのチェックを行う
  before_action :ensure_domain

  # Deviseを使用している場合に限り、パラメータの設定を行う
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ユーザーがログインしていない場合、ログインページへリダイレクト
  def authenticate_user
    unless user_signed_in?
      flash[:notice] = "Es necesario iniciar sesión"
      redirect_to new_user_session_path
    end
  end

  # ログイン済みユーザーがログインページにアクセスした場合にサービスページへリダイレクト
  def forbid_login_user
    if current_user
      flash[:notice] = "Ya has iniciado sesión"
      redirect_to services_path
    end
  end

  protected

  # ユーザーがサインインした後のリダイレクト先をroot_pathに設定
  def after_sign_in_path_for(resource)
    root_path
  end

  # Deviseのパラメータ設定（コメントアウト中）
  def configure_permitted_parameters
    #devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number, :profile_image])
  end

  # ドメインが許可されたものかチェックし、許可されていない場合は禁止レスポンスを返す
  def ensure_domain
    # 未対応 [重要度: 低] アクセスの制限を一部でしているが、本来的にはこのような処理はインフラレイヤーで行うべき。
    # 不要なアクセスをRailsで受けることになるため、不要なサーバーリソースを使うことになるため。また実装不備によりこの処理が通らなかったときに重要な不具合となる可能性を秘めます。
    # Herokuでどこまで行えるかという問題もありますので、重要度を低。Herokuの間は、あまり気にしなくても良い。
    # Herokuのデフォルトドメインのみ許可
    return unless /\.herokuapp.com/ =~ request.host

    # ポート番号が標準ポートでなければURLに追加
    port = ":#{request.port}" unless [80, 443].include?(request.port)
    redirect_url = "#{request.protocol}#{FQDN}#{port}#{request.path}"
    redirect_host = URI.parse(redirect_url).host

    # 許可されたホストならリダイレクト、そうでなければアクセス禁止
    if ALLOWED_HOSTS.include?(redirect_host)
      redirect_to redirect_url, status: :moved_permanently, allow_other_host: true
    else
      render plain: 'Not Allowed', status: :forbidden
    end
  end
end

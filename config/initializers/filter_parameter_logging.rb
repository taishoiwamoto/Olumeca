#このファイルは、Railsアプリケーションのログフィルタリング設定をカスタマイズするための設定ファイルです。
#config/initializers/filter_parameter_logging.rbに位置し、
#ログファイルに出力される際に特定のパラメーターをフィルタリング（隠蔽）するために使用されます。
#これは、パスワードや秘密鍵、トークンなどの機密情報がログに記録されることを防ぐために重要です。

# Be sure to restart your server when you modify this file.

# Configure parameters to be filtered from the log file. Use this to limit dissemination of
# sensitive information. See the ActiveSupport::ParameterFilter documentation for supported
# notations and behaviors.
Rails.application.config.filter_parameters += [
  :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn
]

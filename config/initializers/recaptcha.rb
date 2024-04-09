#このコードスニペットは、RailsアプリケーションでreCAPTCHAを設定するためのものです。
#reCAPTCHAは、Googleが提供するサービスで、ウェブサイトにアクセスするのが人間か自動化されたボットかを判別するために使用されます。
#これにより、スパムや不正なアクセスからウェブサイトを保護することができます。

Recaptcha.configure do |config|
  config.site_key   = ENV['RECAPTCHA_SITE_KEY']
  config.secret_key = ENV['RECAPTCHA_SECRET_KEY']
end

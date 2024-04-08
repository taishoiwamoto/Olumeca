#このコードスニペットは、RailsアプリケーションでreCAPTCHAを設定するためのものです。
#reCAPTCHAは、Googleが提供するサービスで、ウェブサイトにアクセスするのが人間か自動化されたボットかを判別するために使用されます。
#これにより、スパムや不正なアクセスからウェブサイトを保護することができます。

Recaptcha.configure do |config|
  config.site_key   = '6LedoAgoAAAAACiRtGAbzOqpCqXqVOVRjP3ClyV9'
  config.secret_key = '6LedoAgoAAAAALtq7xsGPKwURRbuD1osnBVHOqhz'
end

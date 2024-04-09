Recaptcha.configure do |config|
  ENV['RECAPTCHA_SITE_KEY']   = Rails.application.credentials.recaptcha[:site_key]
  ENV['RECAPTCHA_SECRET_KEY'] = Rails.application.credentials.recaptcha[:secret_key]
end

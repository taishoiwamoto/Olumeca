class ApplicationMailer < ActionMailer::Base
  # メールのデフォルト送信元アドレスを設定します。
  default from: "contact@lecmarket.com"
  # ActionMailerで使用するデフォルトのレイアウトファイルを指定します。
  layout "mailer"
end

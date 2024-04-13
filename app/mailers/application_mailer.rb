# ApplicationMailerクラス: ActionMailer::Baseを継承しています。
# これはアプリケーション全体で使用されるメーラーの基底クラスとして機能し、
# 共通の設定やビューを提供します。
class ApplicationMailer < ActionMailer::Base
  # メールのデフォルト送信元アドレスを設定します。
  # すべてのメール送信においてこのアドレスが使用されることがデフォルトになります。
  default from: "contact@lecmarket.com"

  # メール送信時のレイアウトファイルを指定します。
  # "mailer"というレイアウトがメールの基本的なレイアウトとして使用されます。
  # これにより、すべてのメールに共通のデザインやヘッダー、フッターを適用することができます。
  layout "mailer"
end

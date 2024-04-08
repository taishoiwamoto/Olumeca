#この設定スニペットは、RailsアプリケーションでHTTP Permissions Policyを定義するためのものです。
#Permissions Policy（以前のFeature Policy）は、ウェブブラウザが特定の機能（カメラ、マイクロフォン、ジャイロスコープなど）への
#アクセスをどのように許可するかを制御するためのメカニズムです。
#これにより、ウェブサイトの開発者は、自分のウェブページや特定のフレーム内でこれらの機能が使用されることを制限したり、完全に禁止したりすることができます。

#この機能は、ユーザーのプライバシーを守り、意図しない形で機能が使用されるのを防ぐために役立ちます。
#例えば、アプリケーションがユーザーのカメラやマイクロフォンにアクセスすることを全面的に禁止したい場合や、
#特定の支払い方法を許可するドメインを制限したい場合に有効です。

# Define an application-wide HTTP permissions policy. For further
# information see https://developers.google.com/web/updates/2018/06/feature-policy
#
# Rails.application.config.permissions_policy do |f|
#   f.camera      :none
#   f.gyroscope   :none
#   f.microphone  :none
#   f.usb         :none
#   f.fullscreen  :self
#   f.payment     :self, "https://secure.example.com"
# end

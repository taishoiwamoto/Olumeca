# ApplicationCable名前空間の定義。Railsの標準的な慣習に従って、
# アプリケーション内の全てのActionCable関連のクラスはこの名前空間内に配置されます。
module ApplicationCable
  # ActionCable::Channel::Baseを継承することで、
  # カスタムチャネルクラスにActionCableの基本的な機能を提供します。
  # これにより、WebSocket接続を介したクライアントとサーバー間の通信が可能になります。
  class Channel < ActionCable::Channel::Base
  end
end

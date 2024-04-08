#このファイルは、Kaminari gemの設定ファイルです。
#Kaminariは、Railsアプリケーションでページネーション（ページごとのデータ表示）を簡単に実装できるようにするRubyのgemです。
#この設定ファイルでは、ページネーションの動作をカスタマイズするための様々なオプションが設定できますが、
#ここでは全ての設定がコメントアウトされており、デフォルト値が使用されます。

# frozen_string_literal: true

Kaminari.configure do |config|
  # config.default_per_page = 25
  # config.max_per_page = nil
  # config.window = 4
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
  # config.max_pages = nil
  # config.params_on_first_page = false
end

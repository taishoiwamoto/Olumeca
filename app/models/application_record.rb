# このクラスはRailsの全てのモデルが継承するベースクラスとして機能します。
# ActiveRecord::Baseを継承しており、アプリケーション内の他の全てのモデルが共通の振る舞いを持つことができるようにします。
# `primary_abstract_class` メソッドを使用して抽象クラスとして設定されています。これにより、
# ApplicationRecord自体はデータベーステーブルに直接対応しないが、継承する子クラスがデータベーステーブルと対応します。

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end

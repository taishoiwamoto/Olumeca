#ApplicationRecordはRails 5以降のバージョンで導入され、全てのモデルが継承すべき基底クラスとして機能します：
class ApplicationRecord < ActiveRecord::Base
  # `primary_abstract_class`メソッドを呼び出して、このクラスが抽象クラスであることを指定します。
  # 抽象クラスとは、インスタンス化されることなく、他のクラスの継承のためだけに存在するクラスのことです。
  # この設定により、ApplicationRecord自体はテーブルに紐付けられず、アプリケーション内の全てのモデルで共通の振る舞いや設定を定義するための基盤として機能します。
  primary_abstract_class
end

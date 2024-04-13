class HomeController < ApplicationController
  # topアクション: トップページのデータを取得し、ビューに渡す
  def top
    # Serviceモデルから状態がアクティブなものを作成日時の降順で取得し、最新の4件のみ取得する
    # Service はデータベースのテーブルに関連付けられたモデルクラスであり、データに対する操作(CRUD操作)を行うメソッドを提供します。
    # @services はそのクラス（または他のクラス）から取得されたデータの集まりを保持するためのインスタンス変数であり、コントローラからビューへデータを渡すために使用されます。
    @services = Service.active.order(created_at: :desc).limit(4)
  end
end

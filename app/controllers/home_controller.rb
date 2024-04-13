class HomeController < ApplicationController
  # topアクション: トップページのデータを取得し、ビューに渡す
  def top
    # Serviceモデルから状態がアクティブなものを作成日時の降順で取得し、最新の4件のみ取得する
    @services = Service.active.order(created_at: :desc).limit(4)
  end
end

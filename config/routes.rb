Rails.application.routes.draw do
  # ルーティングを登録するファイルです。 ルーティングというのは、ブラウザからRailsアプリへ渡される情報をもとに、登録された動きを行わせるための振り分け設定 

  # ルートページをhomeコントローラのtopアクションに設定
  root "home#top"

  # 静的ページのルート
  get 'static_pages/privacy_policy'
  get 'static_pages/terms_of_service'

  # Deviseユーザー認証関連のルート設定
  # devise_for :usersを通じてユーザーモデルに対する認証ルートを生成
  # controllers オプションを使用して、Deviseのデフォルトのコントローラをカスタムコントローラにオーバーライド。
  # これにより、デフォルトの動作をカスタマイズ。
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'}

  # 特定のユーザーを削除するためのルート
  # match 'users.:id' => 'registrations#destroy'：この部分はregistrations コントローラの destroy アクションにルーティングするための設定。
  # 'users.:id' は、URLにユーザーのIDを含めることを指定しており、このIDをパラメータとしてdestroyアクションに渡します。
  # :via => :delete：これはHTTPメソッドとしてDELETEを指定しています。DELETEメソッドは、RESTful API（分散型システムにおける複数のソフトウェアを連携させるのに適した設計原則の集合、考え方）においてリソースを削除するための標準的な方法。
  # :as => :destroy_user：これは名前付きルートを設定しており、このルートにdestroy_user_pathやdestroy_user_urlといったヘルパーメソッドでアクセスできるようにしています。
  # これにより、ビューやコントローラー内でこのルートを簡単に参照できます。
  match 'users.:id' => 'registrations#destroy', :via => :delete, :as => :destroy_user

  # ユーザー関連のルート、限定的なリソースのみ使用
  # ユーザーリソースの中でeditアクションとshowアクションに対するルートのみを生成する
  resources :users, only: [:edit, :show] do
    # memberブロック内では、特定のユーザーに関連する追加のアクションのルートを定義しています。
    member do
      # get :likes：各ユーザーの「いいね！」リストを表示するためのページへのルート
      get :likes
      # get :orders：ユーザーの注文履歴を表示するためのページへのルートです。
      get :orders
      # get :sales：ユーザーが行った販売の履歴を表示するためのページへのルートです。
      get :sales
    end
  end

  # サービスとレビュー関連のネストされたリソース
  # ユーザーはサービスに対してレビューを投稿したり、既存のレビューを編集することができます。
  # ネストされているため、URLはservices/:service_id/reviews/:idの形式で、サービスIDに基づいてレビューを管理することができます。
  resources :services do
    resources :reviews, only: [:new, :create, :edit, :update]

    # collection doブロック内のpost '/filter', to: 'services#filter'は、servicesリソースに対するカスタムのルートを定義しています。
    # このpostリクエストはservices#filterアクションにマッピングされ、これを使用してサービスを特定の基準でフィルタリングするフォームを処理します。
    collection do
      post '/filter', to: 'services#filter' # サービスをフィルターするアクション
    end
  end

  # いいね機能のルート
  resources :likes, only: [:create, :destroy]

  # 注文関連のルート
  resources :orders do
    # collection doブロック内のget :completedは、注文リソース全体に関連するカスタムアクションを定義
    # 完了した注文の一覧を表示するページに対するルートを提供
    # collectionキーワードは、このアクションが特定の注文のIDに依存しないことを意味する
    # つまり、このルートは/orders/completedの形でアクセスされ、すべての完了した注文を一覧表示するページへと導きます。
    collection do
      get :completed # 完了した注文の表示
    end
    # memberキーワードは、これらのアクションが特定の注文のIDに対して適用されることを意味する
    # URLはそれぞれ/orders/:id/acceptと/orders/:id/rejectの形になります
    # putメソッドは、注文の状態を変更するために使用され、これにより注文の状態が「承認された」または「拒否された」に更新されます。
    member do
      put :accept  # 注文の承認
      put :reject  # 注文の拒否
    end
  end
end

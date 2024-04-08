#このファイルは、Ruby on Railsアプリケーションでのルーティングの設定を定義しています。
#ルーティングは、アプリケーションに届くリクエストを適切なコントローラーとアクションに振り分けるためのルールを設定するものです。
#ここでの設定は、特定のURLに対するアクセスをどのように扱うかを定義しています。

Rails.application.routes.draw do
  # ホームページ（ルートURL）へのルーティングをHomeControllerのtopアクションに指定します。
  root "home#top"
  # 静的ページへのルーティング設定。プライバシーポリシーと利用規約ページへのアクセスを定義。
  get 'static_pages/privacy_policy'
  get 'static_pages/terms_of_service'

  # ユーザー認証に関連するルーティング。Devise gemを使用しており、
  # 各種認証関連のアクション（確認メール、パスワード再設定、登録、セッション管理、アンロック）をカスタムコントローラに指定しています。
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'}

  # ユーザー削除のためのルーティング。HTTP DELETEリクエストをRegistrationsコントローラーのdestroyアクションにマッピングします。
  match 'users.:id' => 'registrations#destroy', :via => :delete, :as => :destroy_user

  # ユーザーに関連するリソース（編集、表示）へのルーティング。さらに、ユーザーの「いいね」、「注文」、「販売」ページへのルーティングをmemberメソッドで追加。
  resources :users, only: [:edit, :show] do
    member do
      get :likes
      get :orders
      get :sales
    end
  end

  # サービスに関連するリソースルーティング。レビューの新規作成、編集に関するネストされたリソースと、
  # サービスのフィルタリング機能へのルーティングを含みます。
  resources :services do
    resources :reviews, only: [:new, :create, :edit, :update]

    collection do
      post '/filter', to: 'services#filter'
    end
  end

  # お気に入りの作成と削除に関するルーティング。
  resources :likes, only: [:create, :destroy]

  # 注文に関連するリソースルーティング。注文が完了したページの表示、注文の受け入れと拒否に関するアクションを定義。
  resources :orders do
    collection do
      get :completed
    end
    member do
      put :accept
      put :reject
    end
  end
end

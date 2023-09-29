Rails.application.routes.draw do
  root "home#top"
  get 'static_pages/privacy_policy'
  get 'static_pages/terms_of_service'

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'}

  match 'users.:id' => 'registrations#destroy', :via => :delete, :as => :destroy_user

  resources :users, only: [:edit, :show] do
    member do
      get :likes
      get :orders
      get :sales
      get :reviews
    end
  end
  resources :services do
    post '/send_email', to: 'services#send_email', on: :collection
  end

  resources :plans, only: [], param: :index do
    member do
      delete '(:id)' => "plans#destroy", as: ""
      post '/' => "plans#create"
    end
  end

  get 'plans/:id' => 'plans#show'

  resources :likes, only: [:create, :destroy]

  resources :orders do
    collection do
      get :completed
    end
    member do
      put :accept
      put :reject
    end
  end

  resources :reviews, only: [:new, :create, :edit, :update]
end

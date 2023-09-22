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

  match 'users/:id' => 'users#destroy', :via => :delete, :as => :destroy_user

  resources :users, only: [:edit, :show] do
    member do
      get :likes
      get :orders
      get :sales
      get :reviews
    end
  end
  resources :services

  resources :plans, only: [], param: :index do
    member do
      delete '(:id)' => "plans#destroy", as: ""
      post '/' => "plans#create"
    end
  end

  resources :likes, only: [:create, :destroy]

  resources :orders do
    collection do
      get :completed
    end
  end

  resources :reviews, only: [:new, :create, :edit, :update]
end

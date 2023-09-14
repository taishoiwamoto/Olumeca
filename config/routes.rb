Rails.application.routes.draw do
  root "home#top"
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }

  resources :users, only: [:edit, :show] do
    member do
      get :likes
      get :orders
      get :sales
      get :reviews # この行を追加
    end
  end
  resources :services

  resources :likes, only: [:create, :destroy]

  resources :orders do
    collection do
      get :completed
    end
  end

  resources :reviews, only: [:new, :create, :edit, :update]
end

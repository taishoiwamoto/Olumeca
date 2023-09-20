Rails.application.routes.draw do
  root "home#top"
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'}

  resources :users, only: [:edit, :show] do
    member do
      get :likes
      get :orders
      get :sales
      get :reviews
    end
  end
  resources :services

  resources :plans

  resources :likes, only: [:create, :destroy]

  resources :orders do
    collection do
      get :completed
    end
  end

  resources :reviews, only: [:new, :create, :edit, :update]
end

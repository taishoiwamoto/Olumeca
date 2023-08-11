Rails.application.routes.draw do
  get 'contacts/new'
  get 'contacts/create'
  get "likes/:service_id/create" => "likes#create"
  get "likes/:service_id/destroy" => "likes#destroy"

  post "users/:id/update" => "users#update"
  get "users/:id/edit" => "users#edit"
  post "users/create" => "users#create"
  get "signup" => "users#new"
  get "users/:id" => "users#show"
  post "login" => "users#login"
  get "logout" => "users#logout"
  get "login" => "users#login_form"
  get "users/:id/likes" => "users#likes"
  get "users/:id/destroy" => "users#destroy"

  get "services/index" => "services#index"
  get "services/new" =>  "services#new"
  get 'services/:id', to: 'services#show', as: 'service'
  post "services/create" => "services#create"
  get "services/:id/edit" => "services#edit"
  post "services/:id/update" => "services#update"
  get "services/:id/destroy" => "services#destroy"

 # resources :contacts, only: [:new, :create]

  get "/" => "home#top"
  get "about" => "home#about"
  get "about" => "home#about"
end

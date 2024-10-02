Rails.application.routes.draw do
  root   "home#index"
  get    "/signup",  to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  resources :users do
    resources :tasks 
    resources :user_avatars, only: [:index, :create, :update]
    member do
      get 'completion_rates'
    end
  end
  resources :avatars, only: [:index, :show]
  
end

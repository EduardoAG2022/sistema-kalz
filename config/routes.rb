Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  root to: redirect("/users/sign_in")

  get "dashboard", to: "dashboard#index", as: :dashboard

  resources :products
  resources :customers
  resources :orders do
    member do
      patch :complete
      patch :cancel
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end

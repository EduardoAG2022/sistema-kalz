Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  root to: redirect("/users/sign_in")

  get "dashboard", to: "dashboard#index", as: :dashboard

  resources :products
  resources :suppliers
  resources :purchases do
    member do
      patch :mark_in_transit
      patch :mark_in_stock
    end
  end
  resources :customers
  resources :orders do
    member do
      patch :complete
      patch :cancel
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end

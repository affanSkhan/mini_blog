Rails.application.routes.draw do
  # Sidekiq Web UI (admin only)
  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Devise routes for user authentication
  devise_for :users

  # Root route - homepage for unauthenticated users
  root "home#index"

  # Dashboard route - requires authentication
  get "dashboard", to: "dashboard#index", as: :dashboard

  # Admin namespace
  namespace :admin do
    get 'dashboard', to: 'dashboard#index', as: :dashboard
    resources :users, only: [:index, :show, :update, :destroy] do
      member do
        patch :toggle_admin
        patch :soft_delete
      end
      resources :posts, only: [:index]
    end
  end

  # Posts routes with friendly_id support and nested comments
  resources :posts, param: :slug do
    resources :comments, only: [:create, :destroy]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end

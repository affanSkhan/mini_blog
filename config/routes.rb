Rails.application.routes.draw do
  # Sidekiq Web UI (admin only)
  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Rails Admin removed - using custom admin dashboard instead

  # Devise routes for user authentication
  devise_for :users

  # Root route - homepage for unauthenticated users
  root "home#index"

  # Dashboard route - requires authentication
  get "dashboard", to: "dashboard#index", as: :dashboard

  # API Explorer route
  get "api-explorer", to: "home#api_explorer", as: :api_explorer

  # Admin namespace
  namespace :admin do
    get 'dashboard', to: 'dashboard#index', as: :dashboard
    get 'analytics', to: 'analytics#index', as: :analytics
    get 'analytics/export', to: 'analytics#export', as: :analytics_export
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

  # API Routes
  namespace :api do
    namespace :v1 do
      # Authentication routes
      post 'auth/login', to: 'auth#login'
      post 'auth/register', to: 'auth#register'
      delete 'auth/logout', to: 'auth#logout'
      get 'auth/me', to: 'auth#me'
      
      # Posts routes
      resources :posts, param: :slug do
        resources :comments, only: [:index, :show, :create, :update, :destroy]
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Additional health checks for debugging
  get "health/check" => "health#check", as: :health_check
  get "health/posts" => "health#posts_test", as: :health_posts

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end

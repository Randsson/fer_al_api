Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  namespace :api do
    namespace :v1 do
      # Authentication routes
      scope :auth do
        post 'register', to: 'authentication#register'
        post 'login', to: 'authentication#login'
        get 'profile', to: 'authentication#profile'
        put 'profile', to: 'authentication#update_profile'
      end

      # Categories routes
      resources :categories, except: [:new, :edit]

      # Events routes
      resources :events, except: [:new, :edit] do
        member do
          post 'toggle_interest'
          post 'images', to: 'events#add_image'
        end
        
        collection do
          get 'search'
          get 'featured'
          get 'upcoming'
        end

        # Nested reviews
        resources :reviews, except: [:new, :edit]
      end

      # Events by category
      get 'events/by_category/:category_id', to: 'events#by_category'

      # User's own reviews
      get 'reviews/my_reviews', to: 'reviews#my_reviews'

      # Notifications routes
      resources :notifications, only: [:index, :show, :update] do
        member do
          patch 'mark_as_read'
        end
        collection do
          patch 'mark_all_as_read'
        end
      end

      # Admin routes
      namespace :admin do
        resources :users, only: [:index, :show, :update, :destroy]
        resources :events, only: [:index, :update, :destroy] do
          member do
            patch 'toggle_featured'
            patch 'change_status'
          end
        end
        get 'dashboard', to: 'dashboard#index'
      end
    end
  end

  # Root route
  root 'api/v1/events#index'
end

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount ActionCable.server => "/cable"

  mount_devise_token_auth_for 'User', at: 'auth'

  root to: 'home#index'

  # this route created for testing API
  get '/about' => 'home#about'

  # Lots routing
  resources :lots, except: [:new, :edit] do
    collection do
      # route for show my lots
      get '/mylots' => 'lots#mylots'
    end
    resources :bids, only: [:create]
    resource :orders, only: [:create] do 
      # post "create", to: "orders#create"
      put :sent
      put :delivered
    end
    
  end
  
end

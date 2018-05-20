Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  root to: 'home#index'

  # this route created for testing API
  get '/about' => 'home#about'

  # Lots routing
  resources :lots
  # route for show my lots
  get '/mylots' => 'lots#mylots'
  
  
end

Coworkers::Application.routes.draw do
  root to: "sessions#new"
  
  match '/auth' => 'sessions#authenticate', via: :get, as: :authenticate
  match '/auth/callback' => 'sessions#create', via: :get, as: :authentication_callback
  
  resource :account, only: :show
  resources :spaces, only: :show
  
  if (path = Rails.root.join('config', 'environments', "#{Rails.env}_routes.rb")).exist?
    eval File.read(path)
  end
end

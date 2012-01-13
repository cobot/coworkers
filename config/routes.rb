Coworkers::Application.routes.draw do
  root to: "sessions#new"

  match '/auth' => 'sessions#authenticate', via: :get, as: :authenticate
  match '/auth/callback' => 'sessions#create', via: :get, as: :authentication_callback

  resource :account, only: [:show, :edit, :update]
  resources :spaces, only: [:show, :update] do
    resources :memberships, only: [:show, :destroy]
    resources :questions, only: [:index, :create, :destroy]
    resource :profile, only: [:edit, :update]
    resources :message_boards, only: [:index, :new, :create]
  end
  resource :session, only: :destroy

  namespace 'api' do
    resources :spaces, only: :show do
      resources :memberships, only: :show
    end
  end

  if (path = Rails.root.join('config', 'environments', "#{Rails.env}_routes.rb")).exist?
    eval File.read(path)
  end
end

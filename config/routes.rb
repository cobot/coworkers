Coworkers::Application.routes.draw do
  root to: "sessions#new"

  match '/auth' => 'sessions#authenticate', via: :get, as: :authenticate
  match '/auth/callback' => 'sessions#create', via: :get, as: :authentication_callback

  resource :account, only: [:show, :edit, :update]
  resources :spaces, only: [:show, :update] do
    resource :membership_import, only: [:new, :create]
    resources :memberships, only: [:index, :show, :destroy]
    resources :questions, only: [:index, :create, :destroy]
    resource :profile, only: [:edit, :update]
    resources :message_boards, only: [:index, :new, :create, :show, :destroy] do
      resources :messages, only: [:create, :edit, :update, :show]
    end
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

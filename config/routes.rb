Coworkers::Application.routes.draw do
  root to: "sessions#new"

  get '/auth/:provider/callback', :to => 'sessions#create', as: :authenticate
  get '/auth/failure', :to => 'sessions#failure'

  resource :account, only: :show
  resources :spaces, only: [:show, :update] do
    member do
      put :install
    end
    resource :membership_import, only: [:new, :create]
    resources :memberships, only: [:index, :show, :destroy, :edit, :update] do
      member do
        put :picture
      end
    end
    resources :questions, only: [:index, :create, :destroy]
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

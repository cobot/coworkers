Coworkers::Application.routes.draw do
  root to: 'sessions#show'

  get '/auth/:provider/callback', to: 'sessions#create', as: :authenticate
  get '/auth/failure', to: 'sessions#failure'

  resource :account, only: :show
  resources :spaces, only: [] do
    member do
      put :install
    end
    resource :membership_import, only: [:new, :create]
    resources :memberships, only: [:index, :show, :destroy, :update]
    resources :questions, only: [:index, :create, :destroy, :edit, :update]
    resource :member_cancellation_webhook, only: :create
  end
  resource :session, only: [:destroy, :new]

  namespace 'api' do
    resources :spaces, only: :show do
      resources :memberships, only: :show
    end
  end

  if (path = Rails.root.join('config', 'environments', "#{Rails.env}_routes.rb")).exist?
    eval File.read(path)
  end
end

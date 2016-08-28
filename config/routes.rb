Rails.application.routes.draw do
  root to: 'pages#index'
  get 'comments/index'
  get 'login', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'

  resources :repos do
    resources :tags
  end

  resources :tags
  resource :highlighter, only: [:show, :create]
  resources :forms
  resources :comments do
    collection do
      post :normal_create
    end
  end
  resources :sessions, only: [:create]

  namespace :pages do
    get :girls
    get :send_mail
    get :exception
    get :vertical_center
    get :bilibili_gifs
  end

  namespace :d do
    resources :photos do
      collection do
        get :random
      end
    end

    resources :bilibili_gifs, only: [:index]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end

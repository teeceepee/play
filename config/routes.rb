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
    get :bilibili_random
    get :gallery
    get :web_socket
    get :chat
  end

  namespace :d do
    resources :photos do
      collection do
        get :random
      end
    end

    resources :bilibili_gifs, only: [:index] do
      collection do
        get :random
      end
    end
  end

  mount EchoServer.new, at: '/ws/echo_server', as: :echo_server
  mount BroadcastServer.new, at: '/ws/broadcast_server', as: :broadcast_server


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end

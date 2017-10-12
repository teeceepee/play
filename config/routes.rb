Rails.application.routes.draw do
  root to: 'buyers#index', constraints: {domain: 'xiumaijia.com'}
  root to: 'pages#index'
  get 'y/(*custom)', to: 'articles#draft'

  resources :taobao_items, path: :items, param: :item_no, only: [:index, :show]
  resources :taobao_reviews, path: :reviews, param: :review_no, only: [:show]

  get 'asgard', to: 'asgard#index'
  namespace :asgard do
    resources :taobao_items, only: [:index, :create]
  end

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
  resources :pictures, only: [:index, :show, :create], param: :pid
  resources :articles, only: [:index, :show, :new, :edit, :create, :update]

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
    get :hupu_news_list
    get :path_diff
    get :time_zone
    get :navigation
    get :background
    get :dns
  end

  namespace :demos do
    get :material
    get :show, to: redirect('https://www.xiumaijia.com', status: 301)
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

  mount LetsencryptPlugin::Engine, at: '/'  # It must be at root level


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end

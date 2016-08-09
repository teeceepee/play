Rails.application.routes.draw do

  get 'comments/index'

  get 'comment/index'

  root to: 'pages#index'

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

  namespace :pages do
    get :girls
    get :send_mail
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end

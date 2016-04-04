Rails.application.routes.draw do

  root to: 'pages#index'

  resources :repos do
    resources :tags
  end

  resources :tags
  resource :highlighter, only: [:show, :create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end

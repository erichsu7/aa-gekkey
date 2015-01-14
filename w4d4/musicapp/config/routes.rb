Rails.application.routes.draw do
  get 'artists/index'

  root to: "artists#index"
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  resources :artists do 
    resources :albums, only: :new
  end
  resources :albums, except: [:index, :new] do
    resources :tracks, only: :new
  end
  resources :tracks, except: [:index, :new] do
    resources :notes, only: :create
  end
  resource :notes, only: :destroy
end

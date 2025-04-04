Rails.application.routes.draw do
  root "twitch_streamers#index"
  resources :twitch_streamers, only: [:index, :show, :new, :create, :destroy]
  resources :youtube_streamers, only: [:index, :show]
  devise_for :users
  resources :viewer_snapshots, only: [:index] do
    get :analytics, on: :collection
  end
end

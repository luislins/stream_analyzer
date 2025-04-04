Rails.application.routes.draw do
  root "twitch_streamers#index"
  resources :twitch_streamers, only: [:index, :show, :new, :create, :destroy]
  resources :youtube_streamers, only: [:index, :show]
  devise_for :users
  resources :viewer_snapshots, only: [:index] do
    get :analytics, on: :collection
  end
  
  # Test routes
  get 'test/delete_all_snapshots', to: 'viewer_snapshots#delete_all_snapshots'
end

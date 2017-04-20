Rails.application.routes.draw do
  resources :playlists do
    resources :songs
  end
  post '/search', to: 'search#index'
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end
Rails.application.routes.draw do
  resources :playlists do
    resources :songs
  end
end
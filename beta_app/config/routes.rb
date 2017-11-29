Rails.application.routes.draw do
  resources :songs
  devise_for :users
  resources :music_groups
  resources :albums

  get '/auth/spotify/callback', to: 'users#spotify'

  get 'static_pages/home'
  get 'static_pages/help'

  get 'posts/news_feed'

  get 'static_pages/search_page'
  post 'static_pages/search_page'
  post 'static_pages/advanced_search'
  get 'static_pages/advanced_search'

  get 'users/upload_center'

  resources :posts

  resources :users do
      member do
          post 'follow_playlist'
          get 'edit_profile_picture', to: 'profile_picture_picker#choose_picture'
          post 'update_profile_picture', to: 'profile_picture_picker#update_profile_picture'
          get 'change_password', to: 'users#change_password'
          put 'password_confirm_and_set', to: 'users#password_confirm_and_set'
      end
  end

  resources :playlist_songs

  # syntax controller#action
  # controller: users_controller
  # action: def index (in file users_controller.rb)
  root 'static_pages#home'



  resources :playlists do
    member do
        post 'change_index'
        post 'delete_song'
    end
  end

  resources :user_follow_playlists

  get '/news_feed', to: 'posts#news_feed'
  get '/upload_center', to: 'users#upload_center'
  get '/search', to: 'static_pages#search_page'
  get 'public_playlists', to: 'playlists#public_playlists'

  get 'dashboard', to: 'dashboard#dashboard'

  post 'album_ratings/create'
  patch 'album_ratings/update'

  post 'song_ratings/create'
  patch 'song_ratings/update'

  post  'relationships/create'
  delete 'relationships/delete'

  post 'favorited_songs/create'
  delete 'favorited_songs/delete'

  post 'user_comments/create'

  resources :users do
    member do
        get :following
    end
  end




end

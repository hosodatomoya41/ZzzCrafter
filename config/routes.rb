Rails.application.routes.draw do
  root 'static_pages#top'

  post '/callback' => 'linebot#callback'
  post '/send_line_message', to: 'linebot#send_message'
  
  get '/users', to: 'users#show', as: 'users'
  get '/users/edit', to: 'users#edit', as: 'users_edit'
  get '/profile/routine_records', to: 'users#routine_records', as: 'profile_routine_records'
  
  resources :users, only: %i[new create update] do
    collection do
      get :recommend_routines
      post :recommend_routines
      get :routine_records
    end
  end
  resources :routines, only: %i[index show]
  resources :sleep_records, only: %i[index new create]
  
end

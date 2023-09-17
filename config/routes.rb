Rails.application.routes.draw do
  root 'static_pages#top'

  post '/callback' => 'linebot#callback'
  post '/send_line_message', to: 'linebot#send_message'
  
  get '/profile', to: 'users#show', as: 'profile'
  get '/profile/routine_records', to: 'users#routine_records', as: 'profile_routine_records'

  resources :users, only: %i[new create]
  resources :routines, only: %i[index show]
  resources :sleep_records, only: %i[index new create]
  
end
  
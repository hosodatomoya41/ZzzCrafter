Rails.application.routes.draw do
  root 'static_pages#index'

  post '/callback' => 'linebot#callback'
  
  get '/profile', to: 'users#show', as: 'profile'

  get '/logout', to: 'users#destroy'
  get '/logout_success', to: 'users#logout_success'
  
  resources :users, only: %i[new create]
  resources :routines, only: %i[index show]
  resources :sleep_records, only: %i[index new create]
  
end
  
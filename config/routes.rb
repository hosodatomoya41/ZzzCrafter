# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#top'

  post '/callback' => 'linebot#callback'
  post '/send_line_message', to: 'linebot#send_message'

  get '/users', to: 'users#show', as: 'users'
  get '/users/edit', to: 'users#edit', as: 'users_edit'

  post 'routines', to: 'routines#index'

  resources :users, only: %i[new create update]
  resources :routines, only: %i[index show]
  resources :sleep_records, only: %i[index new create]
end

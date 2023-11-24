# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#top'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'

  post '/callback' => 'linebot#callback'
  post '/send_line_message', to: 'linebot#send_message'

  get '/users', to: 'users#show', as: 'users'
  get '/users/edit', to: 'users#edit', as: 'users_edit'
  get 'recommend_routines', to: 'users#recommend_routine'

  post 'routines', to: 'routines#index'

  resources :users, only: %i[new create update]
  resources :routines, only: %i[index show]
  resources :sleep_records, only: %i[index new create]
end

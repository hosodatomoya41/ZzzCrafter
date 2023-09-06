Rails.application.routes.draw do
  root 'static_pages#index'
  
  resources :users, only: %i[new create show]
  resources :routines, only: %i[index]
  resources :sleep_records, only: %i[index new create]
  
end

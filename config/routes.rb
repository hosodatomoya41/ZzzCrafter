Rails.application.routes.draw do
  root 'static_pages#index'
  
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  
  get 'user', to: 'users#show', as: 'user_page'

  resources :users, only: %i[new create]
  
end

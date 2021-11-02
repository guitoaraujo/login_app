Rails.application.routes.draw do
  root 'users#index'

  get 'home', to: 'welcome#home'

  resources :users, only: %i[index]
  post 'login', to: 'users#login'
  delete 'logout', to: 'users#logout'
end

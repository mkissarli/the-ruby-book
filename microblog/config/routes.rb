Rails.application.routes.draw do
  get 'users/new'
  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  resources :users

  get '/login', to: 'session#new'
  post '/login', to: 'session#create'
  delete 'logout', to: 'session#destroy'
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

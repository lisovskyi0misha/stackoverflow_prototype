Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'users/sessions'}
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: 'questions#index'
  resources :questions
  resources :answers
  # Defines the root path route ("/")
  # root "articles#index"
end

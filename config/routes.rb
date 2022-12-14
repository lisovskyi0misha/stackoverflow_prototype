Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'users/sessions'}
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: 'questions#index'
  resources :questions do
    post :vote, on: :member
    resources :answers, except: [:new, :index, :show] do
      post :vote, on: :member
      post :choose_best, on: :member
      delete :delete_best, on: :member
    end
  end
  # Defines the root path route ("/")
  # root "articles#index"
end

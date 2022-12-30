Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { sessions: 'users/sessions', omniauth_callbacks: 'users/omniauth_callbacks' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :questions, only: %i[index show create] do
        resources :answers, only: %i[index show create]
      end
      resources :profiles, only: [] do
        get :me, on: :collection
        get :all, on: :collection
      end
    end
  end
  root to: 'questions#index'
  resources :profiles, only: :index
  resources :questions do
    resources :subscriptions, only: %i[create destroy]
    resources :comments, only: :create
    get 'comments/:answer_id/new', to: 'comments#new_for_answer', as: :new_answer_comment
    get 'comments/new', to: 'comments#new_for_question', as: :new_comment
    post :vote, on: :member
    resources :answers, except: %i[new index show] do
      post :vote, on: :member
      post :choose_best, on: :member
      delete :delete_best, on: :member
    end
  end

  mount ActionCable.server => '/cable'
  # Defines the root path route ("/")
  # root "articles#index"
end

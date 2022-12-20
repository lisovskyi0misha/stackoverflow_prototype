Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', omniauth_callbacks: 'users/omniauth_callbacks' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: 'questions#index'
  resources :questions do
    resources :comments, only: [:create]
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

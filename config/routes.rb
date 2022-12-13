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
  resources :comments, only: [:create]
  get 'comments/:answer_id/new', to: 'comments#new_for_answer', as: :new_answer_comment
  get 'comments/:question_id/new', to: 'comments#new_for_question', as: :new_question_comment


  mount ActionCable.server => '/cable'
  # Defines the root path route ("/")
  # root "articles#index"
end

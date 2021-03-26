Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :reports do
    resources :bookmarks, only: [:show, :destroy]
    resources :comments,  only: [:create, :destroy]
  end

  resources :teams do
    member do
      post :change_owner
      post :charge_in_person
    end
    resources :assigns, only: [:create, :destroy]
    resources :reports
  end

  root 'users#index'
  post 'bookmark/:id' => 'bookmarks#create', as: 'create_bookmark'
  delete 'bookmark/:id' => 'bookmarks#destroy', as: 'destroy_bookmark'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    authenticated :user do
      root :to => 'users#current_user_home', as: :authenticated_root
    end
    unauthenticated :user do
      root :to => 'devise/sessions#new', as: :unauthenticated_root
    end
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  resources :users do
    member do
      get :calendar
    end
  end

  resources :reports do
    collection do
      get :archive
    end
    member do
      post :approval_request
      post :approval
      post :reject
    end
    resources :bookmarks,   only: [:show, :destroy]
    resources :comments,    only: [:create, :edit, :update, :destroy]
    resources :attachments, only: [:create, :destroy]
  end

  resources :teams do
    member do
      post :change_owner
    end
    resources :assigns, only: [:create, :destroy]
    resources :reports
  end

  post 'bookmark/:id' => 'bookmarks#create', as: 'create_bookmark'
  delete 'bookmark/:id' => 'bookmarks#destroy', as: 'destroy_bookmark'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

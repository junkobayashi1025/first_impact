Rails.application.routes.draw do
  devise_for :users

  resources :users

  resources :teams do
    resources :assigns, only: [:create, :destroy]
  end

  root 'users#index'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

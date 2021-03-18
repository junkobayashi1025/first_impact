Rails.application.routes.draw do
  devise_for :users
  resources :users
  root 'users#index'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

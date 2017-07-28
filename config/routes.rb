Rails.application.routes.draw do
  devise_for :users

  resources :tickets
  root 'tickets#index'
end

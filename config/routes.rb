Rails.application.routes.draw do

  resources :members
  resources :teams do
    resources :reports
  end
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

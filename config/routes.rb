Rails.application.routes.draw do
  resources :pools
  get "api_action/:payload", to: 'main#api_action', as: 'api_action'
  get "modify_pool/:id", to: 'main#modify_pool' , as: 'modify_pool'

  root 'main#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

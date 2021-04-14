Rails.application.routes.draw do
  resources :pools, except: [:create]
  get '/toggle_leds', to: 'main#toggle_leds'
  get '/reconfigure_wifi', to: 'main#reconfigure_wifi'
  get "/pools/:id/make_active", to: 'pools#make_active', as: 'make_pool_active'
  get "api_action/:payload", to: 'main#api_action', as: 'api_action'

  root 'main#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

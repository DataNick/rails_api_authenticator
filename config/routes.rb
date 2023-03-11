Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :auth_verification]
      get '/auth_verification', to: 'users#auth_verification'
      post '/auth/login', to: 'authentication#login'
      delete '/auth/logout', to: 'authentication#logout'
    end
  end
end

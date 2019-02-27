Rails.application.routes.draw do
  get 'login',                    to: 'sessions#new'
  get 'logout',                   to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'

  unless Rails.env.production? # for developer OmniAuth provider
    post '/auth/:provider/callback', to: 'sessions#create'
  end
end

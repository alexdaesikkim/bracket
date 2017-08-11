Rails.application.routes.draw do
  resources :tournaments
  resources :qualifiers
  resources :players
  resources :picks
  resources :matchsets
  resources :matches
  resources :games

  get '/tournaments/:id/start' => 'tournaments#start', as: :tournament_start
  get '/tournaments/:id/qualifier_start' => 'tournaments#qualifier_start', as: :tournament_qualifier_start, via: :tournament
  post '/playerqualifiers/update_qualifier/' => 'playerqualifiers#update_qualifier'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

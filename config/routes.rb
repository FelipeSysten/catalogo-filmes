# config/routes.rb
Rails.application.routes.draw do
 

  root 'movies#index'

  
  devise_for :users


  resources :movies do
    collection do # <--- Início do bloco de coleção
      get :search_ai # Rota: /movies/search_ai que mapeia para MoviesController#search_ai
    end           # <--- Fim do bloco de coleção
    resources :comments, only: [:create, :destroy]
  end


  get 'sobre', to: 'pages#about', as: :about

  
  get "up" => "rails/health#show", as: :rails_health_check
end
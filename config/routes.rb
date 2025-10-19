# config/routes.rb
Rails.application.routes.draw do
  root 'movies#index' # Define a página de listagem de filmes como a raiz

  devise_for :users # Rotas de autenticação do Devise

  # Rotas completas para filmes (CRUD)
  # Isso gera GET /movies, GET /movies/:id, GET /movies/new, POST /movies, etc.
  resources :movies do
    # Comentários aninhados em filmes (apenas para create e destroy)
    resources :comments, only: [:create, :destroy]
  end

  # Rota para o health check (pode ignorar por enquanto, se preferir)
  get "up" => "rails/health#show", as: :rails_health_check
end
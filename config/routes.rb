# config/routes.rb
Rails.application.routes.draw do
  # Define a página de listagem de filmes como a raiz
  root 'movies#index'

  # Rotas de autenticação do Devise
  # Isso gera rotas como:
  # - new_user_session_path (GET /users/sign_in) para o login ("Entrar")
  # - destroy_user_session_path (DELETE /users/sign_out) para o logout ("Sair")
  # - new_user_registration_path (GET /users/sign_up) para o cadastro de novo usuário
  # - edit_user_registration_path (GET /users/edit) para editar o perfil do usuário (pode ser usado para "Minha Conta")
  devise_for :users

  # Rotas completas para filmes (CRUD)
  resources :movies do
    # Comentários aninhados em filmes (apenas para create e destroy)
    resources :comments, only: [:create, :destroy]
  end

  # --- Rotas para páginas estáticas ---
  # Rota para a página "Sobre"
  # URL: /sobre
  # Controller/Action: PagesController#about
  # Helper: about_path
  get 'sobre', to: 'pages#about', as: :about

  # --- Rotas para funcionalidades de usuário autenticado ---
  # Rota para a página "Minha Conta" (quando o usuário está logado)
  # Esta rota pode ser usada para exibir ou editar o perfil do usuário logado.
  # Você pode apontá-la para a action 'edit' do Devise, ou para uma action personalizada
  # em um UsersController/ProfileController.
  #
  # Opção 1: Aponta para a action de edição de registro do Devise
  # URL: /minha-conta
  # Controller/Action: Devise::RegistrationsController#edit
  # Helper: user_account_path
  get 'minha-conta', to: 'devise/registrations#edit', as: :user_account

  # Opção 2 (Alternativa, se quiser um controller dedicado para o perfil):
  # get 'minha-conta', to: 'users#show_profile', as: :user_account
  # Nesse caso, você precisaria de um UsersController com uma action `show_profile`.


  # Rota para o health check do Rails (manter)
  get "up" => "rails/health#show", as: :rails_health_check
end
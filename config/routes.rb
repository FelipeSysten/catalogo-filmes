Rails.application.routes.draw do
 

  root 'movies#index'

  
  devise_for :users


  resources :movies do
    collection do 
      get :search_ai 
    end           
    resources :comments, only: [:create, :destroy]
  end


  get 'sobre', to: 'pages#about', as: :about

  
  get "up" => "rails/health#show", as: :rails_health_check
end
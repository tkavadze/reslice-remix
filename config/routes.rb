Rails.application.routes.draw do
  # Authentication
  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  delete "sign_out", to: "sessions#destroy"

  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  # Boards
  resources :boards do
    resources :columns, only: [:create, :update, :destroy] do
      member do
        patch :move
      end
      resources :cards, only: [:create, :update, :destroy] do
        member do
          patch :move
        end
      end
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root
  root "boards#index"
end

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root to: "pages#bienvenue"

  get "/accueil", to: "pages#accueil"

  resources :clubs, only: %i[index show]

  resources :players, only: %i[index show edit update] do
    collection do
      get "filter_by_position"
    end
    resources :bookings, only: %i[show new create]
  end

  resource :dashboard, only: %i[show]

  namespace :dashboard do
    resources :players, only: %i[index] do
      collection do
        get :loaned_out
        get :loaned_in
      end
    end
    resources :bookings, only: %i[index show] do
      member do
        patch :accept
        patch :refuse
      end
    end
  end
end

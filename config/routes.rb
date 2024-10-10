Rails.application.routes.draw do
  use_doorkeeper
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "questions#index"
  use_doorkeeper do
    controllers applications: 'oauth/applications'
  end
  namespace :api do
    namespace :v1 do
      use_doorkeeper

      resource :profiles, only: [] do
        get 'me', on: :collection
        get '', on: :collection, to: 'profiles#index'
      end

      resources :questions, except: [:new, :edit] do
        resources :answers, only: [:index, :show, :create, :update, :destroy]

        resources :comments, only: [:index], module: :questions
      end

      resources :answers, only: [] do
        resources :comments, only: [:index], module: :answers
      end
    end
  end

  resources :questions do
    member do
      patch :mark_best_answer
      patch :unmark_best_answer
    end

    resources :answers, shallow: true, except: [ :index, :show ] do
      resources :comments, shallow: true, only: [ :new, :create ]
    end

    resources :comments, shallow: true, only: [ :new, :create ]
  end

  resources :attachments, only: [ :destroy ]
  resources :links, only: [ :destroy ]
  resources :rewards, only: :index
  resources :votes, only: [ :create ] do
    collection do
      delete :destroy, to: 'votes#destroy', as: 'delete_vote'
    end
  end
  resources :live_feed, only: [ :index ]

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

end

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "questions#index"
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

# frozen_string_literal: true

git_commit = ENV.fetch('GIT_COMMIT') { %x(git rev-parse --short HEAD).strip }

Rails.application.routes.draw do
  root to: 'application#landing'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  mount ActionCable.server, at: '/cable'

  get :health, to: ->(_env) { [200, {}, [{ build: ENV.fetch('GIT_COMMIT') { git_commit } }.to_json]] }

  get '/budget/show_ads', to: 'budget#show_ads', as: :show_budget_ads
  get '/budget/:maker/:model', to: 'budget#show_model', as: :show_model
  get '/budget/:maker/:model/:year', to: 'budget#show_model_year', as: :show_model_year
  get '/budget/(:price)', to: 'budget#search_models', as: :search_models

  get :ios, to: redirect('https://apps.apple.com/us/app/id1458212603')
  get :android, to: redirect('https://play.google.com/store/apps/details?id=com.viktorvsk.recario')
  get :news, to: redirect('https://t.me/reCar_io')
  get :chat, to: redirect('https://t.me/reCar_io_chat')

  resources :ads, only: %i[show]

  namespace :api do
    get :filters, to: '/application#filters'
    namespace :v1 do
      resource :contact_book, only: %i[update destroy]
      resource :user, only: %i[show update]
      resource :sessions, only: %i[create update destroy]

      resources :ads, only: %i[show]
      resources :friendly_ads, only: %i[show]

      resources :user_contacts, only: %i[index]

      resources :favorite_ads, only: %i[index create destroy]
      resources :visited_ads, only: %i[index]
      resources :my_ads, only: %i[index]
      resources :provider_ads, only: %w[index] do
        put :update_ad, on: :collection
        delete :delete_ad, on: :collection
      end
      resources :feed_ads, only: %i[index]
      resources :chat_rooms, only: %w[create index]
      resources :chat_room_users, only: %w[create destroy]
      resources :messages, only: %w[index]
    end

    namespace :v2 do
      resources :friendly_ads, only: %i[show]
    end
  end
end

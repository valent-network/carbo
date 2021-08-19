# frozen_string_literal: true

git_commit = ENV.fetch('GIT_COMMIT') { %x(git rev-parse --short HEAD).strip }

Rails.application.routes.draw do
  root to: 'application#landing'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  mount ActionCable.server, at: '/cable'

  authenticate :admin_user do
    mount ActiveAnalytics::Engine, at: 'analytics'
  end

  get :health, to: ->(_env) { [200, {}, [{ build: ENV.fetch('GIT_COMMIT') { git_commit } }.to_json]] }

  # TODO: temporary hardcode static pages links here to let serve static content
  # via Rails (instead of nginx)
  get '/tos', to: 'application#static_page', slug: :tos
  get '/privacy', to: 'application#static_page', slug: :privacy

  get '/network', to: 'promo_events#index'

  get '/budget/show_ads', to: 'budget#show_ads', as: :show_budget_ads
  get '/budget/:maker/:model', to: 'budget#show_model', as: :show_model
  get '/budget/:maker/:model/:year', to: 'budget#show_model_year', as: :show_model_year
  get '/budget/(:price)', to: 'budget#search_models', as: :search_models

  get :go, to: 'application#multibutton'

  resources :ads, only: %i[show]

  namespace :api do
    get :filters, to: '/application#filters'
    namespace :v1 do
      resource :contact_book, only: %i[update destroy]
      resource :user, only: %i[show update] do
        post :set_referrer, on: :collection
      end
      resource :sessions, only: %i[create update destroy]

      resources :ads, only: %i[show]
      resources :friendly_ads, only: %i[show]

      resources :user_contacts, only: %i[index]

      resources :favorite_ads, only: %i[index create destroy]
      resources :visited_ads, only: %i[index]
      resources :my_ads, only: %i[index]
      resources :feed_ads, only: %i[index]
      resources :chat_rooms, only: %i[create index]
      resources :chat_room_users, only: %i[create destroy]
      resources :messages, only: %i[index]
      resources :referrers, only: %i[show]
      resource :system_chat_room, only: %i[show]
    end

    namespace :v2 do
      resources :friendly_ads, only: %i[show]
    end
  end
end

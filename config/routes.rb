# frozen_string_literal: true

require "sidekiq/web"

# frozen_string_literal: true

git_commit = ENV.fetch("GIT_COMMIT") { `git rev-parse --short HEAD`.strip }

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  mount ActionCable.server, at: "/cable"

  authenticate :admin_user do
    mount Sidekiq::Web, at: "sidekiq"
  end

  get :health, to: ->(_env) { [200, {}, [{build: ENV.fetch("GIT_COMMIT") { git_commit }}.to_json]] }

  resources :ads, only: %i[show]

  namespace :api do
    get :filters, to: "/application#filters"

    namespace :integrations do
      get :dashboard, action: :show
      get :budget, action: :show
    end

    namespace :v1 do
      resource :settings, only: %i[show]
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
      resources :admin_system_messages, only: %i[index]
      resources :referrers, only: %i[show]
      resources :blocked_user_contacts, only: %i[update]
      resources :admin_system_chat_rooms, only: %i[index show]
      resource :system_chat_room, only: %i[show]
      resource :presigner, only: %i[create]
    end

    namespace :v2 do
      resources :friendly_ads, only: %i[show]
      resources :feed_ads, only: %i[index]
      resources :ads, only: %i[show create update destroy]
      resources :my_ads, only: %i[index]
      resources :favorite_ads, only: %i[index]
      resources :visited_ads, only: %i[index]
    end
  end
end

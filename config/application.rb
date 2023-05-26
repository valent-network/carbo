# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require 'active_job/railtie'
require "active_record/railtie"
require "action_controller/railtie"
# require "action_view/railtie"
# require 'sprockets/railtie'
# require 'active_storage/engine'
# require 'action_mailer/railtie'
require "action_cable/engine"
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Recario
  class Application < Rails::Application
    config.active_record.schema_format = :sql
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults(7.0)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    # config.active_job.queue_adapter = :sidekiq

    config.i18n.available_locales = %i[en uk]
    config.i18n.default_locale = :uk

    config.time_zone = "Europe/Kiev"
    config.active_record.async_query_executor = :global_thread_pool
  end
end

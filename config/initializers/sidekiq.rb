# frozen_string_literal: true

Redis.exists_returns_integer = true

redis_options = {
  host: ENV.fetch('REDIS_SERVICE_HOST', 'localhost'),
  password: ENV.fetch('REDIS_SERVICE_PASSWORD', nil),
  port: ENV.fetch('REDIS_SERVICE_PORT', '6379'),
}

Sidekiq.configure_server do |config|
  config.redis = redis_options
  config.logger.level = defined?(Rails) ? Rails.logger.level : :warn
end

Sidekiq.configure_client do |config|
  config.logger.level = defined?(Rails) ? Rails.logger.level : :warn
  config.redis = redis_options
end

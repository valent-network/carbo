# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = REDIS_CONFIGURATION.except(:host).merge(url: "redis://#{REDIS_CONFIGURATION[:host]}")
  config.logger.level = defined?(Rails) ? Rails.logger.level : :warn
  config.logger = Rails.logger if defined?(Rails)
end

Sidekiq.configure_client do |config|
  config.redis = REDIS_CONFIGURATION.except(:host).merge(url: "redis://#{REDIS_CONFIGURATION[:host]}")
  config.logger.level = defined?(Rails) ? Rails.logger.level : :warn
  config.logger = Rails.logger if defined?(Rails)
end

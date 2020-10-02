# frozen_string_literal: true

Redis.exists_returns_integer = true

Sidekiq.configure_server do |config|
  config.redis = { host: ENV['REDIS_SERVICE_HOST'] }
end

Sidekiq.configure_client do |config|
  config.redis = { host: ENV['REDIS_SERVICE_HOST'] }
end

# frozen_string_literal: true

require "sidekiq/web"

Sidekiq.configure_server do |config|
  config.redis = REDIS_CONFIGURATION.except(:host).merge(url: "redis://#{REDIS_CONFIGURATION[:host]}")
end

Sidekiq.configure_client do |config|
  config.redis = REDIS_CONFIGURATION.except(:host).merge(url: "redis://#{REDIS_CONFIGURATION[:host]}")
end

Sidekiq::Web.use Rack::Session::Cookie, secret: ENV["SECRET_KEY_BASE"]

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_WEB_USERNAME"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_WEB_PASSWORD"]))
end

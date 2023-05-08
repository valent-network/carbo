# frozen_string_literal: true

require "action_cable/subscription_adapter/redis"

ActionCable::SubscriptionAdapter::Redis.redis_connector = lambda do |_config|
  Redis.new(REDIS_CONFIGURATION)
end

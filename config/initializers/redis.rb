# frozen_string_literal: true
REDIS = Redis.new(url: "redis://#{ENV['REDIS_SERVICE_HOST']}:6379")

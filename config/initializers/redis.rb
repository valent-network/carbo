# frozen_string_literal: true
REDIS = Redis.new(url: "redis://#{ENV['REDIS_SERVICE_HOST']}:6379")
REDIS_KEYS = [
  'server.effective_user_contacts.last_refreshed_at',
  'server.effective_ads.last_refreshed_at',
  'provider.crawler.finished_at',
  'provider.proxy.pool'
]

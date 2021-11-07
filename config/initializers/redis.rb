# frozen_string_literal: true
REDIS = Redis.new(
  host: ENV.fetch('REDIS_SERVICE_HOST', 'localhost'),
  password: ENV.fetch('REDIS_SERVICE_PASSWORD', nil),
  port: ENV.fetch('REDIS_SERVICE_PORT', '6379'),
)

REDIS_KEYS = [
  'server.effective_ads.last_refreshed_at',
  'provider.crawler.finished_at',
  'provider.proxy.pool'
]

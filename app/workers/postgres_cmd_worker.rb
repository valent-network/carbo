# frozen_string_literal: true
class PostgresCmdWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'refresh-matviews', retry: true, backtrace: false

  def perform(table_name)

    if effective_ads
      last_refreshed_at = REDIS.get('server.effective_ads.last_refreshed_at')
      return if last_refreshed_at.present? && (Time.zone.now - Time.zone.parse(last_refreshed_at)) < 5
    end

    cmd = [
      'psql',
      '-h',
      ENV['POSTGRESQL_SERVICE_HOST'],
      '-U',
      ENV['POSTGRES_USER'],
      '-d',
      ENV['POSTGRES_DATABASE'],
      '-c',
      "\"REFRESH MATERIALIZED VIEW CONCURRENTLY #{table_name}\""
    ].join(' ')

    %x(#{cmd})

    REDIS.set('server.effective_ads.last_refreshed_at', Time.zone.now) if table_name == 'effective_ads'
  end
end

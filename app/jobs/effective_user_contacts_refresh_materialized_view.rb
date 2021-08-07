# frozen_string_literal: true

class EffectiveUserContactsRefreshMaterializedView
  include Sidekiq::Worker

  sidekiq_options queue: 'refresh-matviews', retry: true, backtrace: false

  def perform
    last_refreshed_at = REDIS.get('server.effective_user_contacts.last_refreshed_at')
    return if last_refreshed_at.present? && (Time.zone.now - Time.zone.parse(last_refreshed_at)) < 5

    %x(psql -h $POSTGRESQL_SERVICE_HOST -U $POSTGRES_USER -d $POSTGRES_DATABASE -c "REFRESH MATERIALIZED VIEW CONCURRENTLY effective_user_contacts")
    REDIS.set('server.effective_user_contacts.last_refreshed_at', Time.zone.now)
  end
end

# frozen_string_literal: true

class PromoEventsRefreshMaterializedView
  include Sidekiq::Worker

  sidekiq_options queue: 'promo', retry: true, backtrace: false

  def perform
    %x(psql -h $POSTGRESQL_SERVICE_HOST -U $POSTGRES_USER -d $POSTGRES_DATABASE -c "REFRESH MATERIALIZED VIEW CONCURRENTLY promo_events_matview")
  end
end

# frozen_string_literal: true

class KnownAdsRefreshMaterializedView
  include Sidekiq::Worker

  sidekiq_options queue: 'refresh-matviews', retry: true, backtrace: false

  def perform
    %x(psql -h $POSTGRESQL_SERVICE_HOST -U $POSTGRES_USER -d $POSTGRES_DATABASE -c "REFRESH MATERIALIZED VIEW known_ads")
  end
end

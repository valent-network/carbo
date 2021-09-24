# frozen_string_literal: true

class BusinessPhoneNumbersRefreshMaterializedView
  include Sidekiq::Worker

  sidekiq_options queue: 'refresh-matviews', retry: true, backtrace: false

  def perform
    %x(psql -h $POSTGRESQL_SERVICE_HOST -U $POSTGRES_USER -d $POSTGRES_DATABASE -c "REFRESH MATERIALIZED VIEW business_phone_numbers")
  end
end

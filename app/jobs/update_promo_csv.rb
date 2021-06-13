# frozen_string_literal: true
class UpdatePromoCsv < ApplicationJob
  PROMO_CSV_LOCAL_TEMP_LOCATION = '/tmp/promo.csv'
  PROMO_CSV_DO_SPACE_LOCATION = 'honda-s2000-iphone-11-results.csv'

  queue_as :default

  def perform
    %x(psql -h $POSTGRESQL_SERVICE_HOST -U $POSTGRES_USER -d $POSTGRES_DATABASE -c '\\copy (SELECT * FROM promo_events_matview) TO '#{PROMO_CSV_LOCAL_TEMP_LOCATION}' WITH csv')

    S3_CLIENT.put_object(bucket: ENV['DO_SPACE_NAME'], key: PROMO_CSV_DO_SPACE_LOCATION, body: File.new(PROMO_CSV_LOCAL_TEMP_LOCATION), acl: 'public-read')
  end
end

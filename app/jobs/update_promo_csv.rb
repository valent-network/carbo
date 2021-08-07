# frozen_string_literal: true
class UpdatePromoCsv
  include Sidekiq::Worker

  sidekiq_options queue: 'promo', retry: true, backtrace: false

  PROMO_CSV_LOCAL_TEMP_LOCATION = '/tmp/promo.csv'
  PROMO_CSV_DO_SPACE_LOCATION = 'honda-s2000-iphone-11-results.csv'

  def perform
    promo_events_sql = <<~SQL
      SELECT id,
             full_phone_number_masked,
             CASE WHEN name = 'sign_up' THEN 'Установка приложения'
                  WHEN name = 'set_referrer' THEN 'Указан пригласивший пользователь'
                  WHEN name = 'invited_user' THEN 'Приглашён пользователь'
             END AS action,
             to_char(created_at AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Kiev', 'DD-MM-YYYY, HH24:MI') AS datetime
      FROM promo_events_matview
      ORDER BY id DESC
    SQL
    %x(psql -h $POSTGRESQL_SERVICE_HOST -U $POSTGRES_USER -d $POSTGRES_DATABASE -c "\\copy (#{promo_events_sql}) TO '#{PROMO_CSV_LOCAL_TEMP_LOCATION}' WITH csv")

    S3_CLIENT.put_object(bucket: ENV['DO_SPACE_NAME'], key: PROMO_CSV_DO_SPACE_LOCATION, body: File.new(PROMO_CSV_LOCAL_TEMP_LOCATION), acl: 'public-read')
  end
end

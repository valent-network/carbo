# frozen_string_literal: true
class ReindexDatabase
  include Sidekiq::Worker

  sidekiq_options queue: 'system', retry: true, backtrace: false

  def perform
    current_db = Rails.configuration.database_configuration[Rails.env]['database']
    %x(psql -h $POSTGRESQL_SERVICE_HOST -U $POSTGRES_USER -d $POSTGRES_DATABASE -c "REINDEX DATABASE #{current_db}")
  end
end

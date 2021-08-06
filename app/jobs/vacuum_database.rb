# frozen_string_literal: true
class VacuumDatabase
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: true, backtrace: false

  def perform
    %x(psql -h $POSTGRESQL_SERVICE_HOST -U $POSTGRES_USER -d $POSTGRES_DATABASE -c "VACUUM")
  end
end

# frozen_string_literal: true
class VacuumDatabase < ApplicationJob
  queue_as :default

  def perform
    %x(psql -h $POSTGRESQL_SERVICE_HOST -U $POSTGRES_USER -d $POSTGRES_DATABASE -c "VACUUM")
  end
end

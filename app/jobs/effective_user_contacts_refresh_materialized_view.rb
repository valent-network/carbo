# frozen_string_literal: true

class EffectiveUserContactsRefreshMaterializedView < ApplicationJob
  queue_as(:default)

  def perform
    %x(psql -h $POSTGRESQL_SERVICE_HOST -U $POSTGRES_USER -d $POSTGRES_DATABASE -c "REFRESH MATERIALIZED VIEW CONCURRENTLY effective_user_contacts")
  end
end

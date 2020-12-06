# frozen_string_literal: true

class BudgetWidgetRefreshMaterializedView < ApplicationJob
  queue_as(:default)

  def perform
    %x(psql -h $POSTGRESQL_SERVICE_HOST -U $POSTGRES_USER -d $POSTGRES_DATABASE -c "REFRESH MATERIALIZED VIEW ads_grouped_by_maker_model_year")
  end
end

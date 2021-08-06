# frozen_string_literal: true

class BudgetWidgetRefreshMaterializedView
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: true, backtrace: false

  def perform
    %x(psql -h $POSTGRESQL_SERVICE_HOST -U $POSTGRES_USER -d $POSTGRES_DATABASE -c "REFRESH MATERIALIZED VIEW ads_grouped_by_maker_model_year")
  end
end

# frozen_string_literal: true
class PgRefreshMview
  include Sidekiq::Worker

  sidekiq_options queue: 'system', retry: true, backtrace: false

  def perform(mview_table_name)
    ActiveRecord::Base.connection.execute("REFRESH MATERIALIZED VIEW CONCURRENTLY #{mview_table_name}")
  end
end

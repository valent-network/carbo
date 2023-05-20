# frozen_string_literal: true

class SnapshotSystemStats
  include Sidekiq::Worker

  sidekiq_options queue: "system", retry: false, backtrace: false

  def perform
    dashboard_stats = JSON.parse(REDIS.get("dashboard_data")).first
    SystemStat.create(data: dashboard_stats)
  end
end

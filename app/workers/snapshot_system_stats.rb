# frozen_string_literal: true
class SnapshotSystemStats
  include Sidekiq::Worker

  sidekiq_options queue: 'system', retry: false, backtrace: false

  def perform
    SystemStat.create(data: DashboardStats.first.as_json)
  end
end

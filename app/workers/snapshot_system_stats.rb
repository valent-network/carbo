# frozen_string_literal: true
class SnapshotSystemStats
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: false, backtrace: false

  def perform
    SystemStat.create(data: DashboardStats.first.as_json)
  end
end

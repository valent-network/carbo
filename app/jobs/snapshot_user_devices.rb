# frozen_string_literal: true
class SnapshotUserDevices
  include Sidekiq::Worker

  sidekiq_options queue: 'analytics', retry: true, backtrace: false

  def perform
    count = UserDevice.where("updated_at >= NOW() - INTERVAL '1 day'").count
    UserDeviceStat.create(user_devices_appeared_count: count)
  end
end

# frozen_string_literal: true
class SnapshotUserDevices < ApplicationJob
  queue_as(:default)

  def perform
    count = UserDevice.where("updated_at >= NOW() - INTERVAL '1 day'").count
    UserDeviceStat.create(user_devices_appeared_count: count)
  end
end

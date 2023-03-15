# frozen_string_literal: true
class AmplitudeEvent
  attr_reader :event

  def initialize(event)
    @event = event
  end

  def to_json
    return @data if @data

    # TODO: this is a quick fix to associate Event with device. Later we should
    # connect them on creation
    device = event.user.user_devices.order(updated_at: :desc).first
    @data = {
      user_id: Digest::MD5.hexdigest(event.user_id.to_s),
      event_type: event.name,
      event_id: event.id,
      insert_id: event.id,
      event_properties: event.data.to_json,
      user_properties: (event.user.admin? ? { 'Cohort' => 'Admins' } : {}),
      time: (event.created_at.to_i * 1000),
    }

    return @data unless device

    @data.merge!({
      device_id: device.id,
      app_version: device.build_version,
      os_name: device.os,
      language: device.locale,
      session_id: (device.session_started_at ? (device.session_started_at.to_i * 1000) : -1),
    })
  end
end

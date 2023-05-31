# frozen_string_literal: true

class CountlyEvent
  attr_reader :event

  def initialize(event)
    @event = event
  end

  def as_json
    return @data if @data

    # TODO: this is a quick fix to associate Event with device. Later we should
    # connect them on creation
    device = event.user.user_devices.order(updated_at: :desc).first
    @data = {
      begin_session: 1,
      events: [
        key: event.name,
        count: 1,
        timestamp: event.created_at.to_i,
        segmentation: event.data.transform_values(&:to_s)
      ]
    }

    return @data unless device

    @data.merge!({
      device_id: device.id,
      metrics: {
        _os: device.os,
        _app_version: device.build_version
      },
      user_details: {
        phone: event.user.phone_number_id,
        custom: {
          admin: event.user.admin?,
          language: device.locale
        }
      }
    })
  end
end

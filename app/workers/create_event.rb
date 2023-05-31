# frozen_string_literal: true

class CreateEvent
  include Sidekiq::Worker

  sidekiq_options queue: "default", retry: true, backtrace: false

  def self.call(event_type, user:, data: {})
    uid = user.is_a?(User) ? user.id : user
    perform_async(uid, event_type.to_s, Time.zone.now.to_i, data.to_json)
  end

  def perform(user_id, event_type, created_at, data)
    params = {
      user_id: user_id,
      name: event_type,
      data: JSON.parse(data),
      created_at: Time.at(created_at)
    }

    event = Event.new(params)

    if event.save
      # AMPLITUDE_CLIENT.send_event(AmplitudeEvent.new(event)) if AMPLITUDE_CLIENT.ready?
      COUNTLY_CLIENT.send_event(CountlyEvent.new(event)) if COUNTLY_CLIENT.ready?
      event
    else
      Sentry.capture_message("[CreateEventFailed] errors=#{event.errors.to_json}", level: :error)
    end
  end
end

# frozen_string_literal: true
class CreateEvent
  include Sidekiq::Worker

  sidekiq_options queue: 'default', retry: true, backtrace: false

  def self.call(event_type, user:, data: {})
    uid = user.is_a?(User) ? user.id : user
    perform_async(uid, event_type.to_s, Time.zone.now.to_i, data.to_json)
  end

  def perform(user_id, event_type, created_at, data)
    params = {
      user_id: user_id,
      name: event_type,
      data: JSON.parse(data),
      created_at: Time.at(created_at),
    }

    event = Event.new(params)

    if event.save
      event
    else
      logger.error("[CreateEventFailed] errors=#{event.errors.to_json}")
    end
  end
end

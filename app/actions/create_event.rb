# frozen_string_literal: true
class CreateEvent
  def self.call(event_type, user:, data: {})
    user.events.create!(name: event_type, data: data)
  end
end

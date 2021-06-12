# frozen_string_literal: true
FactoryBot.define do
  factory :event do
    name { Event::EVENT_TYPES.sample }
    user
    data { {} }
  end
end

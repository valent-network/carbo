# frozen_string_literal: true
FactoryBot.define do
  factory :message do
    body { FFaker::Lorem.sentence }
    chat_room
  end
end

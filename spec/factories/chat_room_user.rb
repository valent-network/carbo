# frozen_string_literal: true

FactoryBot.define do
  factory :chat_room_user do
    chat_room
    user
    name { FFaker::Name.name }
  end
end

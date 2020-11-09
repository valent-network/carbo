# frozen_string_literal: true
FactoryBot.define do
  factory :chat_room_user do
    user
    chat_room
    name { FFaker::Name.name }
  end
end

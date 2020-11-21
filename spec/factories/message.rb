# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    body { FFaker::Lorem.sentences(2).join("\n") }
    chat_room
    before(:create) do |message|
      unless message.system?
        message.user ||= create(:user)
        chat_room_user = message.chat_room.chat_room_users.where(user: message.user).first
        chat_room_user || create(:chat_room_user, user: message.user, chat_room: message.chat_room)
      end
    end
  end
end

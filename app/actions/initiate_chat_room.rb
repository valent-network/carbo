# frozen_string_literal: true

class InitiateChatRoom
  def call(ad_id:, initiator_user_id:, user_id:, user_name:)
    ad = Ad.find(ad_id)
    initiator = User.find(initiator_user_id)
    user = User.find(user_id)

    raise unless initiator.user_contacts.exists?(phone_number: user.phone_number)
    raise if initiator.name.blank?

    chat_room = initiator.chat_rooms.new(ad: ad, ad_title: ad.title)
    initiator_user = chat_room.chat_room_users.new(user: initiator, name: initiator.name)
    invited_user = chat_room.chat_room_users.new(user: user, name: user_name)
    message = chat_room.messages.new(system: true, body: "#{initiator.name} поинтересовался объявлением", extra: {type: :init, name: initiator.name})

    ChatRoom.transaction do
      chat_room.save!
      initiator_user.save!
      invited_user.save!
      message.save!
    end

    initiator_payload = Api::V1::ChatRoomListSerializer.new(initiator, chat_room).first
    user_payload = Api::V1::ChatRoomListSerializer.new(user, chat_room).first
    ApplicationCable::UserChannel.broadcast_to(initiator, type: "initiate_chat", chat: initiator_payload)
    ApplicationCable::UserChannel.broadcast_to(user, type: "chat", chat: user_payload)
    ApplicationCable::UserChannel.broadcast_to(initiator, type: "unread_update", count: Message.unread_messages_for(initiator.id).count)
    ApplicationCable::UserChannel.broadcast_to(user, type: "unread_update", count: Message.unread_messages_for(user.id).count)

    chat_room.chat_room_users.includes(:user).each do |chat_room_user|
      next if chat_room_user.user_id == initiator_user_id

      SendChatMessagePushNotification.new.call(message: message, chat_room_user: chat_room_user)
    end

    CreateEvent.call("chat_room_initiated", user: initiator, data: {ad_id: ad_id, initiator_user_id: initiator_user_id, user_id: user_id})

    chat_room
  end
end

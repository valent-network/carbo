# frozen_string_literal: true

class LeaveChatRoom
  def call(initiator_user_id, chat_room_id)
    chat_room = ChatRoom.find(chat_room_id)
    initiator = User.find(initiator_user_id)

    raise unless initiator.chat_room_users.exists?(chat_room: chat_room)

    initiator_user = chat_room.chat_room_users.find_by(user: initiator)

    message = chat_room.messages.new(system: true, body: "#{initiator_user.name} покинул чат", extra: {type: :left, name: initiator.name}) unless chat_room.system?

    ChatRoom.transaction do
      initiator_user.destroy
      chat_room.touch
      message.save! unless chat_room.system?
    end

    chat_room.reload

    chat_room.chat_room_users.includes(:user).each do |chat_room_user|
      user = chat_room_user.user
      payload = Api::V1::ChatRoomListSerializer.new(user, chat_room).first
      ApplicationCable::UserChannel.broadcast_to(user, type: "chat", chat: payload)
      ApplicationCable::UserChannel.broadcast_to(user, type: "unread_update", count: Message.unread_messages_for(user.id).count)

      if chat_room_user.user_id != initiator_user_id
        SendChatMessagePushNotification.new.call(message: message, chat_room_user: chat_room_user)
      end
    end

    ApplicationCable::UserChannel.broadcast_to(initiator, type: "unread_update", count: Message.unread_messages_for(initiator.id).count)

    CreateEvent.call("chat_room_left", user: initiator, data: {chat_room_id: chat_room_id, initiator_user_id: initiator_user_id})

    chat_room.destroy if chat_room.chat_room_users.count.zero? && !chat_room.system?
    chat_room.chat_room_users
  end
end

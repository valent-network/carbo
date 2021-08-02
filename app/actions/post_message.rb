# frozen_string_literal: true
class PostMessage
  def call(sender:, message:)
    sender_chat_room_user = sender.chat_room_users.find_by(chat_room_id: message[:chat_room_id])
    raise unless sender_chat_room_user

    message = sender_chat_room_user.chat_room.messages.create!(body: message[:text], id: message[:_id], user: sender, chat_room: sender_chat_room_user.chat_room)
    sender_chat_room_user.chat_room.touch
    sender_chat_room_user.touch

    message.chat_room.reload

    message.chat_room.chat_room_users.includes(:user).each do |chat_room_user|
      user = chat_room_user.user
      payload = Api::V1::ChatRoomListSerializer.new(user, message.chat_room).first
      ApplicationCable::UserChannel.broadcast_to(user, type: 'chat', chat: payload)
      if user != sender
        ApplicationCable::UserChannel.broadcast_to(user, type: 'unread_update', count: Message.unread_messages_for(user.id).count)
      end

      if chat_room_user.user_id != sender.id
        SendChatMessagePushNotification.new.call(message: message, chat_room_user: chat_room_user)
      end
    end

    message
  end
end

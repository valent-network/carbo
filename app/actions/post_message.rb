# frozen_string_literal: true
class PostMessage
  def call(sender:, message:)
    chat_room_user = sender.chat_room_users.find_by(chat_room_id: message[:chat_room_id])
    raise unless chat_room_user

    message = chat_room_user.chat_room.messages.create!(body: message[:text], id: message[:_id], user: sender, chat_room: chat_room_user.chat_room)
    chat_room_user.chat_room.touch
    chat_room_user.touch

    message.chat_room.reload

    message.chat_room.users.each do |user|
      payload = Api::V1::ChatRoomSerializer.new(message.chat_room, current_user_id: user.id).as_json
      ApplicationCable::UserChannel.broadcast_to(user, type: 'chat', chat: payload)
    end

    message
  end
end

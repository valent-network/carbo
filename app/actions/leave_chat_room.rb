# frozen_string_literal: true
class LeaveChatRoom
  def call(initiator_user_id, chat_room_id)
    chat_room = ChatRoom.find(chat_room_id)
    initiator = User.find(initiator_user_id)

    raise unless initiator.chat_room_users.exists?(chat_room: chat_room)

    ChatRoom.transaction do
      chat_room.chat_room_users.find_by(user: initiator).destroy
      chat_room.touch
      chat_room.messages.create!(system: true, body: "#{initiator.name || 'Безымянный'} покинул чат")
    end

    payload = Api::V1::ChatRoomSerializer.new(chat_room.reload).as_json

    chat_room.users.each do |u|
      ApplicationCable::UserChannel.broadcast_to(u, type: 'chat', chat: payload)
    end

    chat_room.destroy if chat_room.chat_room_users.count.zero?
  end
end

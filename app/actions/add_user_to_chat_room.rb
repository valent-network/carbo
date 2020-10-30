# frozen_string_literal: true
class AddUserToChatRoom
  def call(initiator_user_id, chat_room_id, user_id)
    chat_room = ChatRoom.find(chat_room_id)
    initiator = User.find(initiator_user_id)
    user = User.find(user_id)

    raise unless initiator.chat_room_users.exists?(chat_room: chat_room)
    raise unless initiator.user_contacts.joins(phone_number: :user).exists?(users: { id: user.id })

    ChatRoom.transaction do
      chat_room.chat_room_users.create!(user: user)
      chat_room.touch
      chat_room.messages.create!(system: true, body: "#{user.name || 'Безымянный'} присоединился к чату")
    end

    payload = Api::V1::ChatRoomSerializer.new(chat_room.reload).as_json

    chat_room.users.each do |u|
      ApplicationCable::UserChannel.broadcast_to(u, type: 'chat', chat: payload)
    end
  end
end

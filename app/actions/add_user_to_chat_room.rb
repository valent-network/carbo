# frozen_string_literal: true
class AddUserToChatRoom
  def call(initiator_user_id, chat_room_id, user_id, name)
    chat_room = ChatRoom.find(chat_room_id)
    initiator = User.find(initiator_user_id)
    user = User.find(user_id)
    initiator_chat_room_user = initiator.chat_room_users.find_by(chat_room: chat_room)

    raise unless initiator_chat_room_user
    raise unless initiator.user_contacts.joins(phone_number: :user).exists?(users: { id: user.id })

    chat_room_user = chat_room.chat_room_users.new(user: user, name: name)
    message = chat_room.messages.new(system: true, body: "#{chat_room_user.name} присоединился к чату", extra: { type: :add, name: chat_room_user.name })

    ChatRoom.transaction do
      chat_room_user.save!
      chat_room.touch
      message.save!
      initiator_chat_room_user.touch
    end

    sender = SendChatMessagePushNotification.new

    chat_room.chat_room_users.includes(:user).each do |cru|
      user = cru.user
      payload = Api::V1::ChatRoomListSerializer.new(user, chat_room).first
      ApplicationCable::UserChannel.broadcast_to(user, type: 'chat', chat: payload)

      if cru.user_id != initiator_user_id
        sender.call(message: message, chat_room_user: cru)
      end
    end

    CreateEvent.call('chat_room_user_added', user: initiator, data: { chat_room_id: chat_room_id, initiator_user_id: initiator_user_id, user_id: user_id })

    chat_room_user
  end
end

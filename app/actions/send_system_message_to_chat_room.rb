# frozen_string_literal: true
class SendSystemMessageToChatRoom
  def call(user_id:, message_text:)
    user = User.find(user_id)

    # We need this workaround to make system notifications work like regular chats
    # User won't see anywhere that this chat is related to any ad
    random_ad = Ad.first
    raise unless random_ad

    chat_room = user.chat_rooms.where(user: user, system: true).first_or_initialize(ad: random_ad)
    target_user = chat_room.chat_room_users.where(user: user).first_or_initialize(name: user.name.presence || 'system')
    message = chat_room.messages.new(body: message_text)

    ChatRoom.transaction do
      chat_room.save!
      target_user.save!
      message.save!
    end

    user_payload = Api::V1::ChatRoomSerializer.new(chat_room, current_user_id: user.id).as_json
    ApplicationCable::UserChannel.broadcast_to(user, type: 'chat', chat: user_payload)
    ApplicationCable::UserChannel.broadcast_to(user, type: 'unread_update', count: Message.unread_messages_for(user.id).count)
  end
end

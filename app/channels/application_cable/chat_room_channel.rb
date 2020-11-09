# frozen_string_literal: true
module ApplicationCable
  class ChatRoomChannel < ApplicationCable::Channel
    def subscribed
      @chat_room = ChatRoom.find(params[:chat_room_id])
      @chat_room_user = @chat_room.chat_room_users.find_by(user: current_user)
      @chat_room_user.touch
      payload = Api::V1::ChatRoomSerializer.new(@chat_room.reload, current_user_id: current_user.id).as_json
      ApplicationCable::UserChannel.broadcast_to(current_user, type: 'read_update', chat: payload)
      stream_for(@chat_room)
    end

    def read(_data)
      @chat_room_user.touch
      payload = Api::V1::ChatRoomSerializer.new(@chat_room, current_user_id: current_user.id).as_json
      ApplicationCable::UserChannel.broadcast_to(current_user, type: 'read_update', chat: payload)
    end

    def destroy(data)
      id = data.with_indifferent_access[:message][:id]
      message = current_user.messages.find(id)

      message.destroy
      updated_at = @chat_room.messages.order(:created_at).last.created_at
      @chat_room.reload
      @chat_room.users.each do |u|
        payload = Api::V1::ChatRoomSerializer.new(@chat_room, current_user_id: u.id).as_json
        ApplicationCable::UserChannel.broadcast_to(u, type: 'chat', chat: payload)
        ApplicationCable::UserChannel.broadcast_to(u, type: 'unread_update', count: Message.unread_messages_for(u.id).count)
        ApplicationCable::UserChannel.broadcast_to(u, type: 'delete_message', id: id, chat_room_id: message.chat_room_id, updated_at: updated_at)
      end
    end

    def receive(data)
      PostMessage.new.call(sender: current_user, message: data.with_indifferent_access[:message])
    end
  end
end

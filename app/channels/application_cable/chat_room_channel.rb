# frozen_string_literal: true
module ApplicationCable
  class ChatRoomChannel < ApplicationCable::Channel
    def subscribed
      @chat_room = ChatRoom.find(params[:chat_room_id])
      @chat_room_user = @chat_room.chat_room_users.find_by(user: current_user)
      @chat_room_user.touch
      stream_for(@chat_room)
    end

    def read(_data)
      @chat_room_user.touch
      payload = Api::V1::ChatRoomSerializer.new(@chat_room, current_user_id: current_user.id).as_json
      ApplicationCable::UserChannel.broadcast_to(current_user, type: 'chat', chat: payload)
    end

    def receive(data)
      PostMessage.new.call(sender: current_user, message: data.with_indifferent_access[:message])
    end
  end
end

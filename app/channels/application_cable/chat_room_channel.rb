# frozen_string_literal: true
module ApplicationCable
  class ChatRoomChannel < ApplicationChannel
    def subscribed
      @chat_room = ChatRoom.eager_load(chat_room_users: [user: :phone_number], ad: [:ad_description, :ad_image_links_set, :city, :ad_query, :ad_extra], messages: [:user, :chat_room]).find(params[:chat_room_id])
      @chat_room_user = @chat_room.chat_room_users.find_by(user: current_user)

      # TODO: user can't receive this from UserChannel if ChatRoomChannel
      # subscription fired before UserChannel subscription
      @chat_room_user.touch
      payload = Api::V1::ChatRoomListSerializer.new(current_user, @chat_room).first
      ApplicationCable::UserChannel.broadcast_to(current_user, type: 'read_update', chat: payload)

      stream_for(@chat_room)
    end

    def read(_data)
      @chat_room_user.touch
      payload = Api::V1::ChatRoomListSerializer.new(current_user, @chat_room).first
      ApplicationCable::UserChannel.broadcast_to(current_user, type: 'read_update', chat: payload)
    end

    def destroy(data)
      id = data.with_indifferent_access[:message][:id]
      message = current_user.messages.find(id)

      message.destroy
      updated_at = @chat_room.messages.order(:created_at).last.created_at
      @chat_room.reload
      @chat_room.users.each do |u|
        payload = Api::V1::ChatRoomListSerializer.new(current_user, @chat_room).first
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

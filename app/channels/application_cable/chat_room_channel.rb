# frozen_string_literal: true
module ApplicationCable
  class ChatRoomChannel < ApplicationChannel
    def subscribed
      @chat_room = ChatRoom.eager_load(chat_room_users: [user: :phone_number], ad: [:ad_description, :ad_image_links_set, :city, :ad_query, :ad_extra], messages: [:user, :chat_room]).find(params[:chat_room_id])
      @chat_room_user = @chat_room.chat_room_users.find_by(user: current_user)

      if params[:from] == 'admin' && current_user.admin? && @chat_room.system?
        @chat_room.update(admin_seen_at: Time.zone.now)
        payload = Api::V1::ChatRoomListSerializer.new(current_user, @chat_room).first
        ApplicationCable::UserChannel.broadcast_to(current_user, type: 'admin_read_update', chat: payload)
        ApplicationCable::UserChannel.broadcast_to(current_user, type: 'unread_update', count: Message.unread_messages_for(current_user.id).count, system_count: Message.unread_system_messages.values.sum)
      else
        # TODO: user can't receive this from UserChannel if ChatRoomChannel
        # subscription fired before UserChannel subscription
        @chat_room_user.touch
        payload = Api::V1::ChatRoomListSerializer.new(current_user, @chat_room).first
        ApplicationCable::UserChannel.broadcast_to(current_user, type: 'read_update', chat: payload)
      end

      stream_for(@chat_room)
    end

    def read(_data)
      @chat_room_user&.touch
      payload = Api::V1::ChatRoomListSerializer.new(current_user, @chat_room).first
      ApplicationCable::UserChannel.broadcast_to(current_user, type: 'read_update', chat: payload)
    end

    def admin_read(_data)
      payload = Api::V1::ChatRoomListSerializer.new(current_user, @chat_room).first
      ApplicationCable::UserChannel.broadcast_to(current_user, type: 'admin_read_update', chat: payload)
      if @chat_room.system? && current_user.admin?
        @chat_room.update(admin_seen_at: Time.zone.now)
        ApplicationCable::UserChannel.broadcast_to(current_user, type: 'unread_update', count: Message.unread_messages_for(current_user.id).count, system_count: Message.unread_system_messages.values.sum)
      end
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
      if current_user.admin? && @chat_room.system? && data[:from] == 'admin'
        chat_room = ChatRoom.find(data['message']['chat_room_id'])
        SendSystemMessageToChatRoom.new.call(user_id: chat_room.user_id, message_text: data['message']['text'], message_id: data['message']['_id'])
        payload = Api::V1::ChatRoomListSerializer.new(current_user, chat_room).first
        ApplicationCable::UserChannel.broadcast_to(current_user, type: 'admin_chat', chat: payload)
      else
        PostMessage.new.call(sender: current_user, message: data.with_indifferent_access[:message])
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class SystemChatRoomsController < ApplicationController
      before_action :require_auth

      def show
        system_chat_room = current_user.chat_rooms.where(system: true).first

        if system_chat_room.present?
          chat_room_user = current_user.chat_room_users.where(chat_room: system_chat_room).first

          if chat_room_user

          else
            current_user.chat_room_users.create(name: current_user.name.presence || 'system', chat_room: system_chat_room)
          end

          # user_payload = Api::V1::ChatRoomListSerializer.new(current_user, system_chat_room).first
          # ApplicationCable::UserChannel.broadcast_to(current_user, type: 'chat', chat: user_payload)
          # ApplicationCable::UserChannel.broadcast_to(current_user, type: 'unread_update', count: Message.unread_messages_for(current_user.id).count)
        else
          system_chat_room = SendSystemMessageToChatRoom.new.call(user_id: current_user.id, message_text: I18n.t('invitation_text'), async: false)
        end

        render(json: { chat_room_id: system_chat_room.id })
      end
    end
  end
end

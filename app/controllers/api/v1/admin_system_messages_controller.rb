# frozen_string_literal: true

module Api
  module V1
    class AdminSystemMessagesController < ApplicationController
      before_action :require_auth, :require_admin

      def index
        chat_room = ChatRoom.includes(ad: [:ad_image_links_set, :ad_query]).joins(:chat_room_users).where(system: true).find(params[:chat_room_id])
        messages = chat_room.messages.eager_load(:chat_room, :user).order(created_at: :desc).offset(params[:offset]).limit(20)
        chat_room_users_names = { chat_room.id => Hash[chat_room.chat_room_users.pluck(:user_id, :name)] }

        serialized_chat_room = Api::V1::ChatRoomListSerializer.new(current_user, chat_room).first
        serialized_messages = ActiveModelSerializers::SerializableResource.new(messages, each_serializer: Api::V1::MessageSerializer, chat_room_users_names: chat_room_users_names).as_json

        payload = {
          chat: serialized_chat_room,
          messages: serialized_messages,
        }

        render(json: payload, adapter: nil)
      end
    end
  end
end

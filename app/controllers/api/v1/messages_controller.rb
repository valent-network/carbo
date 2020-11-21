# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      before_action :require_auth

      def index
        chat_room = ChatRoom.joins(:chat_room_users).where(chat_room_users: { user: current_user }).find(params[:chat_room_id])
        messages = chat_room.messages.includes(:user).order(created_at: :desc).offset(params[:offset]).limit(20)

        payload = {
          chat: Api::V1::ChatRoomSerializer.new(chat_room, current_user_id: current_user.id).as_json,
          messages: ActiveModel::SerializableResource.new(messages, each_serializer: Api::V1::MessageSerializer).as_json,
        }

        render(json: payload)
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      before_action :require_auth

      def index
        chat_room = ChatRoom.joins(:chat_room_users).where(chat_room_users: { user: current_user }).find(params[:chat_id])
        messages = chat_room.messages.includes(:user).order(created_at: :desc).offset(params[:offset]).limit(20)
        messages_payload = ActiveModel::SerializableResource.new(messages, each_serializer: Api::V1::MessageSerializer).as_json
        payload = Api::V1::ChatRoomSerializer.new(chat_room).as_json.merge(messages: messages_payload)
        render(json: payload)
      end

      def create
        message = PostMessage.new.call(sender: current_user, message: params[:message])
        render(json: Api::V1::ChatRoomSerializer.new(message.chat_room).as_json)
      end
    end
  end
end

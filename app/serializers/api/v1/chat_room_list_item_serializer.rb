# frozen_string_literal: true
module Api
  module V1
    class ChatRoomListItemSerializer < ActiveModel::Serializer
      attributes :id, :system, :ad_id, :updated_at, :messages,
        :new_messages_count,
        :title,
        :photo,
        :chat_room_users

      def updated_at
        last_message.created_at
      end

      def messages
        [
          Api::V1::MessageSerializer.new(last_message, chat_room_users_names: @instance_options[:names]).as_json,
        ]
      end

      def new_messages_count
        @instance_options[:new_messages_counts][object.id] || 0
      end

      def title
        @instance_options[:titles][object.ad_id]
      end

      def photo
        @instance_options[:photos][object.ad_id]&.first
      end

      def chat_room_users
        @instance_options[:chat_room_users].group_by(&:chat_room_id)[object.id].map do |chat_room_user|
          Api::V1::ChatRoomUserSerializer.new(chat_room_user).as_json.tap do |u|
            u.delete(:phone_number) unless u[:phone_number].in?(@instance_options[:known])
          end
        end
      end

      private

      def last_message
        @last_message ||= @instance_options[:last_messages][object.id].first
      end
    end
  end
end

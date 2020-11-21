# frozen_string_literal: true
module Api
  module V1
    class ChatRoomSerializer < ActiveModel::Serializer
      attributes :id, :updated_at, :title, :messages, :photo, :ad_id, :chat_room_users, :new_messages_count

      def title
        "#{object.ad.details['maker']} #{object.ad.details['model']} #{object.ad.details['year']}"
      end

      def updated_at
        object.messages.order(:created_at).last.created_at
      end

      def messages
        message = object.messages.order(created_at: :desc).first
        return [] unless message
        [
          Api::V1::MessageSerializer.new(message).as_json,
        ]
      end

      def photo
        images = object.ad.details['images_json_array_tmp']
        images = images.is_a?(String) ? JSON.parse(images) : images
        images.first
      end

      def chat_room_users
        ActiveModel::SerializableResource.new(object.chat_room_users.order(:id), each_serializer: Api::V1::ChatRoomUserSerializer).as_json
      end

      def new_messages_count
        return 0 unless @instance_options[:current_user_id]

        Message.joins("JOIN chat_room_users ON chat_room_users.chat_room_id = messages.chat_room_id AND chat_room_users.user_id = #{@instance_options[:current_user_id]} AND chat_room_users.updated_at < messages.created_at AND chat_room_users.chat_room_id = #{object.id}").count
      end
    end
  end
end

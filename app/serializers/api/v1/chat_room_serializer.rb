# frozen_string_literal: true
module Api
  module V1
    class ChatRoomSerializer < ActiveModel::Serializer
      attributes :id, :updated_at, :title, :messages, :photo, :ad_id, :chat_room_users

      def title
        "#{object.ad.details['maker']} #{object.ad.details['model']} #{object.ad.details['year']}"
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
    end
  end
end

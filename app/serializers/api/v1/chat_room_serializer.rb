# frozen_string_literal: true
module Api
  module V1
    class ChatRoomSerializer < ActiveModel::Serializer
      attributes :id, :updated_at, :title, :system, :messages, :photo, :ad_id, :chat_room_users, :new_messages_count

      def title
        return nil if object.system?
        "#{object.ad.details['maker']} #{object.ad.details['model']} #{object.ad.details['year']}"
      end

      def updated_at
        object.messages.sort_by(&:created_at).last.created_at
      end

      def messages
        message = object.messages.sort_by(&:created_at).first
        return [] unless message
        [
          Api::V1::MessageSerializer.new(message).as_json,
        ]
      end

      def photo
        return '' unless object.ad

        images = object.ad.details['images_json_array_tmp']
        images = images.is_a?(String) ? JSON.parse(images) : images
        images&.first
      end

      def chat_room_users
        # TODO: This must be cover with tests carefully
        # so that real numbers of chat members could not leak to unknown users
        relation = object.chat_room_users.to_a.sort_by(&:id)
        known = UserContact.where(user_id: @instance_options[:current_user_id], phone_number_id: relation.map(&:user).map(&:phone_number_id)).map(&:phone_number).map(&:to_s)

        result = ActiveModelSerializers::SerializableResource.new(relation, each_serializer: Api::V1::ChatRoomUserSerializer).as_json
        result.each { |r| r.delete(:phone_number) unless r[:phone_number].in?(known) }
        result
      end

      def new_messages_count
        return 0 unless @instance_options[:current_user_id]

        Message.joins("JOIN chat_room_users ON chat_room_users.chat_room_id = messages.chat_room_id AND chat_room_users.user_id = #{@instance_options[:current_user_id]} AND chat_room_users.updated_at < messages.created_at AND chat_room_users.chat_room_id = #{object.id}").count
      end
    end
  end
end

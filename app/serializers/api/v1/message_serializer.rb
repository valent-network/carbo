# frozen_string_literal: true

module Api
  module V1
    class MessageSerializer < ActiveModel::Serializer
      attributes :_id, :chat_room_id, :text, :user, :createdAt, :system, :pending, :extra

      def _id
        object.id
      end

      def chat_room_id
        object.chat_room_id
      end

      def text
        object.body
      end

      # TODO: Decide what to do with Message's ChatRoomUser and its #name after User left ChatRoom
      # System notification chat if user_id is nil
      def user
        user_name = if object.user_id.blank?
          I18n.t("recario")
        elsif @instance_options[:chat_room_users_names]
          @instance_options[:chat_room_users_names][object.chat_room_id][object.user_id]
        end

        {
          _id: object.user_id,
          avatar: object.user&.avatar&.url,
          name: user_name
        }
      end

      def pending
        false
      end

      def createdAt
        object.created_at
      end

      def extra
        object.extra || {}
      end
    end
  end
end

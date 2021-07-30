# frozen_string_literal: true
module Api
  module V1
    class MessageSerializer < ActiveModel::Serializer
      attributes :_id, :chat_room_id, :text, :user, :createdAt, :system, :pending

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
        user_name = object.user_id ? ChatRoomUser.select(:name).find_by(chat_room: object.chat_room, user: object.user)&.name : I18n.t('recario')

        {
          _id: object.user_id,
          avatar: object.user&.avatar&.url,
          name: user_name,
        }
      end

      def pending
        false
      end

      def createdAt # rubocop:disable Naming/MethodName
        object.created_at
      end
    end
  end
end

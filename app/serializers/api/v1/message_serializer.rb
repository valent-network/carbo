# frozen_string_literal: true
module Api
  module V1
    class MessageSerializer < ActiveModel::Serializer
      attributes :_id, :chat_id, :text, :user, :createdAt, :system, :pending

      def _id
        object.id
      end

      def chat_id
        object.chat_room_id
      end

      def text
        object.body
      end

      def user
        {
          _id: object.user&.id,
          name: object.user ? (object.user.name || FFaker::Name::FIRST_NAMES_MALE[object.user.id]) : nil,
          avatar: object.user&.avatar&.url,
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

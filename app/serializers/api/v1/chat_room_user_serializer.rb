# frozen_string_literal: true
module Api
  module V1
    class ChatRoomUserSerializer < ActiveModel::Serializer
      attributes :id, :created_at, :updated_at, :name, :avatar, :user_id, :phone_number

      def avatar
        object.user.avatar&.url
      end

      def phone_number
        object.user.phone_number.to_s
      end
    end
  end
end

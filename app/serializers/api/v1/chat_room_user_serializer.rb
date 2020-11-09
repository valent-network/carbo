# frozen_string_literal: true
module Api
  module V1
    class ChatRoomUserSerializer < ActiveModel::Serializer
      attributes :id, :created_at, :updated_at, :name, :avatar, :user_id

      def avatar
        object.user.avatar&.url
      end
    end
  end
end

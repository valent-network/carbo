# frozen_string_literal: true

module Api
  module V1
    class AdFriendSerializer < ActiveModel::Serializer
      attributes :id, :name, :idx, :avatar, :phone_number, :user_id, :user_name

      def idx
        object.is_first_hand ? 1 : 2
      end

      def avatar
        object.phone_number.user&.avatar&.url
      end

      def phone_number
        object.phone_number.to_s
      end

      def user_id
        object.phone_number.user&.id
      end

      def user_name
        object.phone_number.user&.name.presence
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class UserContactSerializer < ActiveModel::Serializer
      attributes :id, :name, :phone, :user, :is_blocked

      def phone
        object.phone_number.to_s
      end

      def user
        return unless object.phone_number.user

        {
          id: object.phone_number.user.id,
          name: object.phone_number.user.name,
          phone_number: object.phone_number.to_s,
          avatar: object.phone_number.user.avatar.url
        }
      end
    end
  end
end

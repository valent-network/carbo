# frozen_string_literal: true
module Api
  module V1
    class UserContactSerializer < ActiveModel::Serializer
      attributes :id, :name, :phone, :user

      def phone
        object.phone_number.to_s
      end

      def user
        return unless object.phone_number.user

        {
          name: object.phone_number.user.name,
          phone_number: object.phone_number.to_s,
          avatar: object.phone_number.user.avatar.url,
        }
      end
    end
  end
end

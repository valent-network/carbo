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

        UserSerializer.new(object.phone_number.user).as_json
      end
    end
  end
end

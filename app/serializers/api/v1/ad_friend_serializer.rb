# frozen_string_literal: true

module Api
  module V1
    class AdFriendSerializer < ActiveModel::Serializer
      attributes :id, :name, :idx, :avatar, :phone_number, :user_id, :user_name

      def idx
        object.hops_count
      end

      # TODO: Fix N1 - caused by using union in UserContact.ad_friends_for_user
      def avatar
        object.phone_number.user&.avatar&.url
      end

      # TODO: Temporarely added smile as indicator
      def phone_number
        case object.hops_count
        when 7
          object.phone_number.to_s
        else
          "#{object.phone_number}\n#{"🤝" * object.hops_count}"
        end
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

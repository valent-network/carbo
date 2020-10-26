# frozen_string_literal: true
module Api
  module V1
    class FriendlyAdsController < ApplicationController
      before_action :require_auth

      def show
        ad = Ad.find(params[:id])

        query = UserRootFriendsForAdQuery.new.call(current_user.id, ad.phone_number_id)
        friends = UserContact.select('friends.*').from("(#{query}) friends").to_a
        original_contacts = current_user.user_contacts.includes(phone_number: :user).where(id: friends.map(&:id)).to_a
        # friends.select!(&:is_first_hand) if friends.detect(&:is_first_hand)

        payload = friends.map do |uc|
          original_contact = original_contacts.detect { |oc| oc.id == uc.id }
          next if original_contact.phone_number_id == ad.phone_number_id && !uc.is_first_hand
          {
            name: uc.name,
            id: uc.id,
            idx: uc.is_first_hand ? 1 : 2,
            avatar: original_contact.phone_number.user&.avatar&.url,
            phone_number: original_contact.phone_number.to_s,
          }
        end.compact

        render(json: payload)
      end
    end
  end
end

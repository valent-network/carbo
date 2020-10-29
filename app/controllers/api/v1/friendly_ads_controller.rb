# frozen_string_literal: true
module Api
  module V1
    class FriendlyAdsController < ApplicationController
      before_action :require_auth

      def show
        ad = Ad.find(params[:id])

        query = UserRootFriendsForAdQuery.new.call(current_user.id, ad.phone_number_id)
        friends = UserContact.select('friends.*')
          .from("(#{query}) friends")
          .joins("JOIN user_contacts AS my_contacts ON my_contacts.id = friends.id AND my_contacts.phone_number_id != #{current_user.phone_number_id}")
          .where("friends.is_first_hand = TRUE OR my_contacts.phone_number_id != #{ad.phone_number_id}")
          .to_a
        original_contacts = current_user.user_contacts.includes(phone_number: :user).where(id: friends.map(&:id)).to_a

        payload = friends.map do |uc|
          original_contact = original_contacts.detect { |oc| oc.id == uc.id }
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

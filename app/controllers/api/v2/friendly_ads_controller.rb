# frozen_string_literal: true
module Api
  module V2
    class FriendlyAdsController < ApplicationController
      before_action :require_auth

      def show
        ad = Ad.where(id: params[:id]).eager_load(ad_options: [:ad_option_type, :ad_option_value]).first
        friends = UserContact.ad_friends_for_user(ad, current_user).includes(phone_number: :user)
        chat_rooms = ChatRoom.joins(:chat_room_users).where(chat_room_users: { user: current_user }, ad: ad)

        payload = {
          friends: ActiveModelSerializers::SerializableResource.new(friends, each_serializer: Api::V1::AdFriendSerializer),
          chats: ActiveModelSerializers::SerializableResource.new(chat_rooms, each_serializer: Api::V1::ChatRoomSerializer, current_user_id: current_user.id),
        }

        render(json: payload)
      end
    end
  end
end

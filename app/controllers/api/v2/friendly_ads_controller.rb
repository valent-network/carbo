# frozen_string_literal: true
module Api
  module V2
    class FriendlyAdsController < ApplicationController
      before_action :require_auth

      def show
        ad = Ad.find(params[:id])
        friends = UserContact.ad_friends_for_user(ad, current_user)
        chat_rooms = ChatRoom.joins(:chat_room_users).includes(ad: [:ad_query]).where(chat_room_users: { user: current_user }, ad: ad)
        serialized_friends = ActiveModelSerializers::SerializableResource.new(friends, each_serializer: Api::V1::AdFriendSerializer).as_json.sort_by { |friend| friend[:idx] }
        serialized_chat_rooms = Api::V1::ChatRoomListSerializer.new(current_user, chat_rooms).call.as_json

        payload = {
          friends: serialized_friends,
          chats: serialized_chat_rooms,
        }

        render(json: payload)
      end
    end
  end
end

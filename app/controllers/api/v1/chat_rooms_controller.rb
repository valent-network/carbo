# frozen_string_literal: true

module Api
  module V1
    class ChatRoomsController < ApplicationController
      before_action :require_auth

      def index
        chat_rooms = ChatRoom.joins(:chat_room_users).where(chat_room_users: { user: current_user }).order(updated_at: :desc).offset(params[:offset]).limit(10)
        render(json: chat_rooms, current_user_id: current_user.id)
      end

      def create
        ad = Ad.find(params[:ad_id])
        friends = UserContact.ad_friends_for_user(ad, current_user).includes(phone_number: :user)
        ad_chat_rooms = ChatRoom.joins(:chat_room_users).where(chat_room_users: { user: current_user }, ad: ad)

        chat_room = InitiateChatRoom.new.call(initiator_user_id: current_user.id, ad_id: ad.id, user_id: params[:user_id], user_name: params[:name])
        payload = {
          chat_room: Api::V1::ChatRoomSerializer.new(chat_room, current_user_id: current_user.id).as_json,
          friends: ActiveModel::SerializableResource.new(friends, each_serializer: Api::V1::AdFriendSerializer),
          chats: ActiveModel::SerializableResource.new(ad_chat_rooms, each_serializer: Api::V1::ChatRoomSerializer, current_user_id: current_user.id),
        }

        render(json: payload)
      end
    end
  end
end

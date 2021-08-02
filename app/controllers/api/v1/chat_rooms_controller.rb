# frozen_string_literal: true

module Api
  module V1
    class ChatRoomsController < ApplicationController
      before_action :require_auth

      def index
        chat_rooms = ChatRoom.includes(ad: [:ad_image_links_set])
          .joins(:chat_room_users)
          .where(chat_room_users: { user: current_user })
          .order(updated_at: :desc)
          .offset(params[:offset])
          .limit(20)

        serialized_chat_rooms = Api::V1::ChatRoomListSerializer.new(current_user, chat_rooms).call

        render(json: serialized_chat_rooms.as_json)
      end

      def create
        ad = Ad.find(params[:ad_id])
        friends = UserContact.ad_friends_for_user(ad, current_user).includes(phone_number: :user)
        ad_chat_rooms = ChatRoom.includes(ad: [:ad_image_links_set]).joins(:chat_room_users).where(chat_room_users: { user: current_user }, ad: ad)
        chat_room = InitiateChatRoom.new.call(ad_id: ad.id, initiator_user_id: current_user.id, user_id: params[:user_id], user_name: params[:name])

        serialized_chat_room = Api::V1::ChatRoomListSerializer.new(current_user, chat_room).first
        serialized_chat_rooms = Api::V1::ChatRoomListSerializer.new(current_user, ad_chat_rooms).call
        serialized_friends = ActiveModelSerializers::SerializableResource.new(friends, each_serializer: Api::V1::AdFriendSerializer)

        payload = {
          chat_room: serialized_chat_room,
          friends: serialized_friends,
          chats: serialized_chat_rooms.as_json,
        }

        render(json: payload)
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class ChatRoomUsersController < ApplicationController
      before_action :require_auth

      def create
        chat_room = ChatRoom.find(params[:chat_room_id])

        AddUserToChatRoom.new.call(current_user.id, chat_room.id, params[:user_id], params[:name])
        friends = UserContact.ad_friends_for_user(chat_room.ad, current_user)
        payload = {
          friends: ActiveModelSerializers::SerializableResource.new(friends, each_serializer: Api::V1::AdFriendSerializer),
          chat_room: Api::V1::ChatRoomListSerializer.new(current_user, chat_room).first
        }

        render(json: payload)
      end

      def destroy
        LeaveChatRoom.new.call(current_user.id, params[:id])
        render(json: {message: :ok})
      end
    end
  end
end

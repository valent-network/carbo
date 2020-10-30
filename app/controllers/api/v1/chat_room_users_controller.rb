# frozen_string_literal: true

module Api
  module V1
    class ChatRoomUsersController < ApplicationController
      before_action :require_auth

      def create
        chat_room = ChatRoom.find(params[:chat_room_id])
        user = User.find(params[:user_id])

        AddUserToChatRoom.new.call(current_user.id, chat_room.id, user.id)
        friends = UserContact.ad_friends_for_user(chat_room.ad, current_user).includes(phone_number: :user)
        payload = ActiveModel::SerializableResource.new(friends, each_serializer: Api::V1::AdFriendSerializer)

        render(json: payload.as_json)
      end

      def destroy
        LeaveChatRoom.new.call(current_user.id, params[:id])
        render(json: { message: :ok })
      end
    end
  end
end

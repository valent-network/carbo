# frozen_string_literal: true

module Api
  module V1
    class ChatRoomsController < ApplicationController
      before_action :require_auth

      def index
        chat_rooms = ChatRoom.joins(:chat_room_users).where(chat_room_users: { user: current_user }).order(updated_at: :desc).offset(params[:offset]).limit(10)
        render(json: chat_rooms)
      end

      def create
        ad = Ad.find(params[:ad_id])
        user = current_user.user_contacts.find(params[:user_id]).phone_number.user

        InitiateChatRoom.new.call(initiator_user_id: current_user.id, ad_id: ad.id, user_id: user.id)
        render(json: { message: :OK })
      end
    end
  end
end

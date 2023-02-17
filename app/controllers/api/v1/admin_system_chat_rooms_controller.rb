# frozen_string_literal: true

module Api
  module V1
    class AdminSystemChatRoomsController < ApplicationController
      before_action :require_auth, :require_admin

      def index
        chat_rooms = ChatRoom.includes(ad: [:ad_image_links_set, :ad_query, :ad_extra])
          .joins(:chat_room_users)
          .where(system: true)
          .order(updated_at: :desc)
          .offset(params[:offset])
          .limit(20)

        serialized_chat_rooms = Api::V1::ChatRoomListSerializer.new(current_user, chat_rooms, true).call

        render(json: serialized_chat_rooms.as_json, adapter: nil)
      end
    end
  end
end

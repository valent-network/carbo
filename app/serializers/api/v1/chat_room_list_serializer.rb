# frozen_string_literal: true

module Api
  module V1
    class ChatRoomListSerializer
      attr_reader :current_user, :chat_rooms, :admin

      def initialize(current_user, chat_rooms, admin = false)
        @current_user = current_user
        @chat_rooms = Array.wrap(chat_rooms)
        @admin = admin
      end

      def call
        ActiveModelSerializers::SerializableResource.new(chat_rooms, instance_options)
      end

      def first
        call.as_json.first
      end

      private

      def chat_room_users
        @chat_room_users ||= ChatRoomUser.where(chat_room: chat_rooms).eager_load(user: :phone_number)
      end

      def last_messages
        @last_messages ||= Message.eager_load(:chat_room, :user).where(chat_room: chat_rooms).last_messages_only.group_by(&:chat_room_id)
      end

      def known
        @known ||= UserContact.eager_load(:phone_number).where(user_id: current_user.id, phone_number_id: chat_room_users.map(&:user).map(&:phone_number)).map(&:phone_number).map(&:to_s)
      end

      def new_messages_counts
        @new_messages_counts ||= if admin
          Message.where(chat_room: chat_rooms).unread_system_messages
        else
          Message.unread_messages_for(current_user.id).where(chat_room: chat_rooms).group("messages.chat_room_id").count
        end
      end

      def titles
        @titles ||= chat_rooms.map { |chat| [chat.ad_id, (chat.ad&.title || chat.ad_title)] }.to_h
      end

      def photos
        @photos ||= AdImageLinksSet.where(ad_id: chat_rooms.map(&:ad_id)).pluck(:ad_id, :value).to_h
      end

      def names
        chat_room_users.each_with_object({}) do |chat_room_user, hsh|
          (hsh[chat_room_user.chat_room_id] ||= {})[chat_room_user.user_id] = chat_room_user.name
        end
      end

      def instance_options
        {
          last_messages: last_messages,
          names: names,
          titles: titles,
          photos: photos,
          known: known,
          new_messages_counts: new_messages_counts,
          chat_room_users: chat_room_users,
          each_serializer: Api::V1::ChatRoomListItemSerializer
        }
      end
    end
  end
end

# frozen_string_literal: true
class RemoveChatRoomUserIdFromMessages < ActiveRecord::Migration[6.0]
  def change
    remove_column(:messages, :chat_room_user_id)
  end
end

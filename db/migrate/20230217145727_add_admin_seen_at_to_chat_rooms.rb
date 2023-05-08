# frozen_string_literal: true

class AddAdminSeenAtToChatRooms < ActiveRecord::Migration[7.0]
  def change
    add_column(:chat_rooms, :admin_seen_at, :datetime)
  end
end

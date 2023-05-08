# frozen_string_literal: true

class AddNameToChatRoomUsers < ActiveRecord::Migration[6.0]
  def change
    add_column(:chat_room_users, :name, :string, null: false)
  end
end

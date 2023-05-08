# frozen_string_literal: true

class CreateChatRoomUsers < ActiveRecord::Migration[6.0]
  def change
    create_table(:chat_room_users) do |t|
      t.belongs_to(:chat_room, null: false)
      t.belongs_to(:user, null: false)
      t.timestamps
    end

    add_index(:chat_room_users, %i[chat_room_id user_id], unique: true)
  end
end

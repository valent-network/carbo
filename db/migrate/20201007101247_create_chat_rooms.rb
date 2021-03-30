# frozen_string_literal: true
class CreateChatRooms < ActiveRecord::Migration[6.0]
  def change
    create_table(:chat_rooms) do |t|
      t.belongs_to(:user, null: false)
      t.belongs_to(:ad, null: false)
      t.timestamps
    end
  end
end

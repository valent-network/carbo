# frozen_string_literal: true

class AdAdTitleToChatRooms < ActiveRecord::Migration[7.0]
  def change
    add_column(:chat_rooms, :ad_title, :string)
  end
end

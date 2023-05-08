# frozen_string_literal: true

class AllowChatRoomsAdIdToBeNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:chat_rooms, :ad_id, true)
  end
end

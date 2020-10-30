# frozen_string_literal: true
class ChatRoomUser < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  has_many :messages
end

# frozen_string_literal: true

class ChatRoomUser < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  has_many :messages
  validates :user_id, uniqueness: {scope: [:chat_room_id]}
  validates :name, presence: true, length: {maximum: 100}

  after_touch :send_message_read

  private

  def send_message_read
    ApplicationCable::UserChannel.broadcast_to(user, type: "unread_update", count: Message.unread_messages_for(user.id).count)
  end
end

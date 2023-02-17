# frozen_string_literal: true
class Message < ApplicationRecord
  self.implicit_order_column = :created_at
  validates :body, presence: true, length: { minimum: 1, maximum: 255 }
  belongs_to :user, optional: true
  belongs_to :chat_room
  has_one :chat_room_user, through: :chat_room, source: :chat_room_users

  def self.unread_messages_for(user_id)
    joins('JOIN chat_room_users ON messages.chat_room_id = chat_room_users.chat_room_id')
      .where('chat_room_users.updated_at < messages.created_at AND chat_room_users.user_id = ?', user_id)
  end

  def self.unread_system_messages
    joins(:chat_room).where('chat_rooms.admin_seen_at < messages.created_at').where(chat_rooms: { system: true }).group('messages.chat_room_id').count
  end

  def self.last_messages_only
    joins("JOIN (SELECT chat_room_id, max(created_at) AS max_date FROM messages GROUP BY chat_room_id ORDER BY chat_room_id) AS x ON x.chat_room_id = messages.chat_room_id AND x.max_date = messages.created_at")
  end
end

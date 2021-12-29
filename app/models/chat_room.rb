# frozen_string_literal: true
class ChatRoom < ApplicationRecord
  belongs_to :ad
  belongs_to :user
  has_many :chat_room_users, dependent: :destroy
  has_many :users, through: :chat_room_users
  has_many :messages, dependent: :destroy

  scope :system_chat_rooms, -> { where(system: true) }
end

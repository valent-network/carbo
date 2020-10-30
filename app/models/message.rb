# frozen_string_literal: true
class Message < ApplicationRecord
  self.implicit_order_column = :created_at
  validates :body, presence: true, length: { minimum: 1, maximum: 255 }
  belongs_to :user, optional: true
  belongs_to :chat_room
end

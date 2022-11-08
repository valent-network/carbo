# frozen_string_literal: true
require 'rails_helper'

RSpec.describe(ChatRoom) do
  it 'belongs_to ad'
  it 'belongs_to user'
  it 'has_many chat_room_users'
  it 'has_many users'
  it 'has_many messages'
end

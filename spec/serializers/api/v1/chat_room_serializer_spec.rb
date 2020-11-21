# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Api::V1::ChatRoomSerializer) do
  it '#title'
  it '#updated_at derived from last Message'
  it '#updated_at derived from self in case of no Messages'
  it '#messages'
  it '#messages may be empty'
  it '#photo'
  it '#chat_room_users'
  it '#new_messages_count'
  it '#new_messages_count may be 0 in case of current_user_id is not provided'
end

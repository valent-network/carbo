# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Api::V1::MessagesController) do
  let(:user) { create(:user) }
  let(:chat_room) { create(:chat_room) }

  before do
    allow(subject).to(receive(:current_user).and_return(user))
  end

  describe '#index' do
    it 'OK' do
      other_user = create(:user)
      create(:chat_room_user, user: user, chat_room: chat_room)
      create(:chat_room_user, user: other_user, chat_room: chat_room)
      message = create(:message, system: true, body: 'System Message', chat_room: chat_room)
      expected_chat = JSON.parse(Api::V1::ChatRoomSerializer.new(chat_room.reload, current_user_id: user.id).to_json)
      expected_messages = JSON.parse(Api::V1::MessageSerializer.new(message).to_json)

      get :index, params: { chat_id: chat_room.id }

      expect(json_body['chat']).to(eq(expected_chat))
      expect(json_body['messages']).to(eq([expected_messages]))
    end
  end
end

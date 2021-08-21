# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Api::V1::ChatRoomsController) do
  let(:user) { create(:user, name: FFaker::Name.name) }
  let(:other_user) { create(:user) }
  let(:ad) { create(:ad) }

  before do
    allow(subject).to(receive(:current_user).and_return(user))
  end

  describe '#index' do
    it 'OK' do
      chat_room = create(:chat_room)
      create(:user_contact, user: user, phone_number: other_user.phone_number)
      create(:chat_room_user, chat_room: chat_room, user: user)
      create(:chat_room_user, chat_room: chat_room, user: other_user)
      create(:message, system: true, body: 'Initiated Chat Room', chat_room: chat_room)

      get :index
      expected_chat_rooms = JSON.parse(Api::V1::ChatRoomListSerializer.new(user, chat_room.reload).first.to_json)
      expect(json_body.first['chat_room_users']).to(match_array(expected_chat_rooms['chat_room_users']))
      expect(json_body).to(match_array([expected_chat_rooms]))
    end
  end

  describe '#create' do
    it 'OK' do
      intro_name = FFaker::Name.name
      # TODO: https://github.com/rspec/rspec-mocks/issues/1306#issuecomment-756079746
      # expect_any_instance_of(InitiateChatRoom).to(receive(:call).with(initiator_user_id: user.id, ad_id: ad.id, user_id: other_user.id.to_s, user_name: intro_name).and_call_original)
      create(:user_contact, user: user, phone_number: other_user.phone_number)
      create(:user_connection, user: user, friend: other_user, connection: other_user)
      expect do
        post(:create, params: { ad_id: ad.id, user_id: other_user.id, name: intro_name })
      end.to(change { ChatRoom.count }.by(1))

      chat_room = ChatRoom.joins(:chat_room_users).where(chat_room_users: { user: user }, ad: ad).first
      expected_chat_room = JSON.parse(Api::V1::ChatRoomListSerializer.new(user, chat_room).first.to_json)

      expect(json_body['chat_room']).to(eq(expected_chat_room))
      expect(json_body['friends']).to(eq([]))
      expect(json_body['chats']).to(eq([expected_chat_room]))
    end
  end
end

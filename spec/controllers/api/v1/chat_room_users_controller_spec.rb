# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Api::V1::ChatRoomUsersController) do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:third_user) { create(:user) }
  let(:chat_room) { create(:chat_room) }

  before do
    allow(subject).to(receive(:current_user).and_return(user))

    user.user_contacts.create(name: FFaker::Name.name, phone_number: third_user.phone_number)
    create(:chat_room_user, user: user, chat_room: chat_room)
    create(:chat_room_user, user: other_user, chat_room: chat_room)
    create(:message, system: true, body: "Initiated ChatRoom", chat_room: chat_room)
  end

  describe "#destroy" do
    it "OK" do
      expect_any_instance_of(LeaveChatRoom).to(receive(:call).with(user.id, chat_room.id.to_s))
      delete :destroy, params: {id: chat_room.id}
      expect(json_body).to(eq("message" => "ok"))
    end
  end

  describe "#create" do
    it "OK" do
      expect_any_instance_of(AddUserToChatRoom).to(receive(:call).with(user.id, chat_room.id, third_user.id.to_s, "John Doe").and_call_original)
      post :create, params: {chat_room_id: chat_room.id, user_id: third_user.id, name: "John Doe"}
      expected_chat = JSON.parse(Api::V1::ChatRoomListSerializer.new(user, chat_room.reload).first.to_json)
      expect(json_body["chat_room"]).to(eq(expected_chat))
      expect(json_body["friends"]).to(eq([]))
    end
  end
end

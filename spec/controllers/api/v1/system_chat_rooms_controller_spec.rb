# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Api::V1::SystemChatRoomsController) do
  let!(:ad) { create(:ad) }
  let(:user) { create(:user) }

  before do
    allow(subject).to(receive(:current_user).and_return(user))
  end

  describe "#show" do
    context "when chat room exists" do
      let!(:system_chat_room) { SendSystemMessageToChatRoom.new.call(user_id: user.id, message_text: "Start") }

      it "shows chat_room_id" do
        get :show
        expect(json_body["chat_room_id"]).to(eq(system_chat_room.id))
      end
    end

    context "when chat room user does not exist" do
      let!(:system_chat_room) { SendSystemMessageToChatRoom.new.call(user_id: user.id, message_text: "Start") }

      before do
        user.chat_room_users.destroy_all
      end

      it "shows chat_room_id" do
        get :show
        expect(json_body["chat_room_id"]).to(eq(system_chat_room.id))
      end
    end

    it "shows chat_room_id" do
      get :show
      expect(json_body["chat_room_id"]).to(be_a(Integer))
    end
  end
end

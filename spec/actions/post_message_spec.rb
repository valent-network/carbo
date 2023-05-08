# frozen_string_literal: true

require "rails_helper"

RSpec.describe(PostMessage) do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:chat_room) { create(:chat_room) }

  before do
    create(:chat_room_user, user: user, chat_room: chat_room)
    create(:chat_room_user, user: other_user, chat_room: chat_room)
    create(:message, system: true, body: "Initiate Chat Room")
    create(:user_contact, user: user, phone_number: other_user.phone_number)
  end

  def post_valid_message
    described_class.new.call(sender: user, message: {chat_room_id: chat_room.id, text: FFaker::Lorem.sentence, _id: SecureRandom.uuid})
  end

  context "Fails when" do
    it "Sender ChatRoomUser does not exist" do
      chat_room.chat_room_users.find_by(user: user).destroy
      expect { described_class.new.call(sender: user, message: {chat_room_id: chat_room.id}) }.to(raise_error(StandardError))
    end
  end

  context "When success" do
    it "Returns created Message record" do
      expect(post_valid_message).to(be_a(Message))
    end

    it "#touch Sender ChatRoomUser" do
      expect { post_valid_message }.to(change { chat_room.chat_room_users.find_by(user: user).updated_at })
    end

    it "#touch ChatRoom" do
      expect { post_valid_message }.to(change { chat_room.reload.updated_at })
    end

    it "Creates Message for Sender" do
      expect { post_valid_message }.to(change { user.messages.where(chat_room: chat_room).count }.by(1))
    end

    it "Broadcasts #chat and #unread_update to all ChatRoomUsers thorugh ActionCable" do
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, hash_including(type: "chat")).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, hash_including(type: "unread_update")).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(other_user, hash_including(type: "chat")).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(other_user, hash_including(type: "unread_update")).once)

      post_valid_message
    end

    it "Sends Push Notification to all ChatRoomUsers except of Initiator" do
      expect_any_instance_of(SendChatMessagePushNotification).to(receive(:call).with(hash_including(chat_room_user: chat_room.chat_room_users.find_by(user: other_user))).once)
      post_valid_message
    end
  end
end

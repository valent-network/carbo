# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(SendSystemMessageToChatRoom) do
  subject { described_class.new.call(user_id: user.id, message_text: message_text) }

  let!(:ad) { create(:ad) }
  let(:user) { create(:user) }
  let(:message_text) { "Hello, world!" }

  context "when no Ads present" do
    before do
      Ad.destroy_all
    end

    it "raises an exception" do
      expect { subject }.to(raise_error(StandardError))
    end
  end

  context "when chat room already exists" do
    it "creates chat room", pending: true
  end

  context "when chat room user already exists" do
    it "creates chat room user", pending: true
  end

  context "when nothing exists" do
    it "creates chat room" do
      expect { subject }.to(change { user.chat_rooms.where(system: true, ad: ad).exists? }.from(false).to(true))
    end

    it "creates chat room user" do
      expect { subject }.to(change { user.chat_room_users.where(name: 'system').exists? }.from(false).to(true))
    end
  end

  it "creates message" do
    expect { subject }.to(change { Message.where(body: message_text).exists? }.from(false).to(true))
  end

  it "returns ChatRoom" do
    expect(subject).to(be_a(ChatRoom))
  end

  it "takes user name if present" do
    user.update(name: 'John')
    expect { subject }.to(change { user.chat_room_users.where(name: 'John').exists? }.from(false).to(true))
  end

  it "triggers broadcasts" do
    expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, { type: 'chat', chat: anything }).once)
    expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, { type: 'unread_update', count: 1 }).once)
    expect_any_instance_of(Api::V1::ChatRoomListSerializer).to(receive(:first).once)
    expect(Api::V1::ChatRoomListSerializer).to(receive(:new).once.and_call_original)
    expect_any_instance_of(SendChatMessagePushNotification).to(receive(:call).once)
    subject
  end

  it "sends proper unread count", pending: true
  it "sends proper payload", pending: true
end

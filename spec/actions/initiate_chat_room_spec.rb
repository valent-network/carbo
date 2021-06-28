# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(InitiateChatRoom) do
  let(:ad) { create(:ad) }
  let(:user) { create(:user, name: FFaker::Name.name) }
  let(:other_user) { create(:user) }

  def initiate_valid_chat_room
    described_class.new.call(ad_id: ad.id, initiator_user_id: user.id, user_id: other_user.id, user_name: FFaker::Name.name)
  end

  before do
    create(:user_contact, user: user, phone_number: other_user.phone_number)
  end

  context 'Fails when' do
    it 'Ad not found' do
      expect do
        described_class.new.call(ad_id: 0, initiator_user_id: user.id, user_id: other_user.id, user_name: FFaker::Name.name)
      end.to(raise_error(ActiveRecord::RecordNotFound))
    end

    it 'Initiator User not found' do
      expect do
        described_class.new.call(ad_id: ad.id, initiator_user_id: 0, user_id: other_user.id, user_name: FFaker::Name.name)
      end.to(raise_error(ActiveRecord::RecordNotFound))
    end

    it 'Invited User not found' do
      expect do
        described_class.new.call(ad_id: ad.id, initiator_user_id: user.id, user_id: 0, user_name: FFaker::Name.name)
      end.to(raise_error(ActiveRecord::RecordNotFound))
    end

    it 'Invited User is not on Initiator contacts list' do
      user.user_contacts.destroy_all
      expect do
        initiate_valid_chat_room
      end.to(raise_error(StandardError))
    end

    it 'Initiator User name is blank' do
      user.update(name: nil)
      expect do
        initiate_valid_chat_room
      end.to(raise_error(StandardError))
    end

    context 'Rollback' do
      it 'Message is not saved for some reason' do
        expect_any_instance_of(Message).to(receive(:save!).and_raise)

        expect(ApplicationCable::UserChannel).to_not(receive(:broadcast_to))
        expect_any_instance_of(SendChatMessagePushNotification).to_not(receive(:call))
        expect { initiate_valid_chat_room }.to(raise_error(StandardError)
          .and(change { ChatRoom.count }.by(0)
          .and(change { ChatRoomUser.count }.by(0)
          .and(change { Message.count }.by(0)))))
      end

      # TODO: Failed once
      it 'ChatRoom is not saved for some reason' do
        expect_any_instance_of(ChatRoom).to(receive(:save!).and_raise)

        expect(ApplicationCable::UserChannel).to_not(receive(:broadcast_to))
        expect_any_instance_of(SendChatMessagePushNotification).to_not(receive(:call))
        expect { initiate_valid_chat_room }.to(raise_error(StandardError)
          .and(change { ChatRoom.count }.by(0)
          .and(change { ChatRoomUser.count }.by(0)
          .and(change { Message.count }.by(0)))))
      end

      it 'ChatRoomUser is not saved for some reason' do
        expect_any_instance_of(ChatRoomUser).to(receive(:save!).and_raise)

        expect(ApplicationCable::UserChannel).to_not(receive(:broadcast_to))
        expect_any_instance_of(SendChatMessagePushNotification).to_not(receive(:call))
        expect { initiate_valid_chat_room }.to(raise_error(StandardError)
          .and(change { ChatRoom.count }.by(0)
          .and(change { ChatRoomUser.count }.by(0)
          .and(change { Message.count }.by(0)))))
      end
    end
  end

  context 'When success' do
    it 'Creates ChatRoom' do
      expect do
        initiate_valid_chat_room
      end.to(change { ChatRoom.count }.by(1))
    end

    it 'Creates ChatRoomUser for Initiator User' do
      expect do
        initiate_valid_chat_room
      end.to(change { ChatRoomUser.joins(:chat_room).exists?(chat_rooms: { ad: ad }, user: user) }.from(false).to(true))
    end

    it 'Creates ChatRoomUser for Invited User' do
      expect do
        initiate_valid_chat_room
      end.to(change { ChatRoomUser.joins(:chat_room).exists?(chat_rooms: { ad: ad }, user: other_user) }.from(false).to(true))
    end

    it 'Creates system Message' do
      expect do
        initiate_valid_chat_room
      end.to(change { Message.exists?(system: true, chat_room: ChatRoom.find_by(ad: ad)) }.from(false).to(true))
    end

    it 'Returns created ChatRoom record' do
      result = initiate_valid_chat_room
      expect(result).to(be_a(ChatRoom))
    end

    it 'Broadcasts events to ActionCable' do
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, hash_including(type: 'initiate_chat')).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, hash_including(type: 'unread_update')).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(other_user, hash_including(type: 'chat')).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(other_user, hash_including(type: 'unread_update')).once)
      initiate_valid_chat_room
    end

    describe 'Sends Push Notifications' do
      it 'but not to Initiator User' do
        expect_any_instance_of(SendChatMessagePushNotification).to(receive(:call).with(hash_including(:message, :chat_room_user)).once) do |_obj, args|
          expect(args[:message]).to(be_a(Message))
          expect(args[:message].system).to(be_truthy)
          expect(args[:chat_room_user]).to(be_a(ChatRoomUser))
          expect(args[:chat_room_user].user).to(eq(other_user))
        end

        initiate_valid_chat_room
      end
    end
  end
end

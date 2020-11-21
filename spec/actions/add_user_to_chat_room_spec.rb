# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AddUserToChatRoom) do
  let(:chat_room) { create(:chat_room) }
  let(:user) { create(:user, name: FFaker::Name.name) }
  let(:other_user) { create(:user) }
  let(:third_user) { create(:user) }

  def invite_valid_user
    described_class.new.call(user.id, chat_room.id, third_user.id, FFaker::Name.name)
  end

  before do
    create(:chat_room_user, user: user, chat_room: chat_room)
    create(:chat_room_user, user: other_user, chat_room: chat_room)
    create(:message, system: true, body: 'Initiate Chat Room')
    create(:user_contact, user: user, phone_number: other_user.phone_number)
    create(:user_contact, user: user, phone_number: third_user.phone_number)
  end

  context 'Fails when' do
    it 'ChatRoom not found' do
      expect do
        described_class.new.call(user.id, 0, third_user.id, FFaker::Name.name)
      end.to(raise_error(ActiveRecord::RecordNotFound))
    end

    it 'Initiator User not found' do
      expect do
        described_class.new.call(0, chat_room.id, third_user.id, FFaker::Name.name)
      end.to(raise_error(ActiveRecord::RecordNotFound))
    end

    it 'Invited Added User not found' do
      expect do
        described_class.new.call(user.id, chat_room.id, 0, FFaker::Name.name)
      end.to(raise_error(ActiveRecord::RecordNotFound))
    end

    it 'Initiator ChatRoomUser not found' do
      chat_room.chat_room_users.where(user: user).destroy_all
      expect { invite_valid_user }.to(raise_error)
    end

    it 'Added User is not on Initiator User contacts list' do
      user.user_contacts.destroy_all
      expect { invite_valid_user }.to(raise_error)
    end

    it 'ChatRoomUser not saved for some reason' do
      expect_any_instance_of(ChatRoomUser).to(receive(:save!).and_raise)

      expect(ApplicationCable::UserChannel).to_not(receive(:broadcast_to))
      expect_any_instance_of(SendChatMessagePushNotification).to_not(receive(:call))
      expect { initiate_valid_chat_room }.to(raise_error
          .and(not_change { chat_room.reload.updated_at }
          .and(not_change { chat_room.chat_room_users.find_by(user: user).reload.updated_at })
          .and(change { ChatRoomUser.count }.by(0)
          .and(change { Message.count }.by(0)))))

      expect { invite_valid_user }.to(raise_error)
    end

    it 'Message not saved for some reason' do
      expect_any_instance_of(Message).to(receive(:save!).and_raise)

      expect(ApplicationCable::UserChannel).to_not(receive(:broadcast_to))
      expect_any_instance_of(SendChatMessagePushNotification).to_not(receive(:call))
      expect { initiate_valid_chat_room }.to(raise_error
          .and(not_change { chat_room.reload.updated_at }
          .and(not_change { chat_room.chat_room_users.find_by(user: user).reload.updated_at })
          .and(change { ChatRoomUser.count }.by(0)
          .and(change { Message.count }.by(0)))))

      expect { invite_valid_user }.to(raise_error)
    end

    it 'ChatRoom#touch didnt work for some reason' do
      expect_any_instance_of(ChatRoom).to(receive(:touch).and_raise)

      expect(ApplicationCable::UserChannel).to_not(receive(:broadcast_to))
      expect_any_instance_of(SendChatMessagePushNotification).to_not(receive(:call))
      expect { initiate_valid_chat_room }.to(raise_error
          .and(not_change { chat_room.reload.updated_at }
          .and(not_change { chat_room.chat_room_users.find_by(user: user).reload.updated_at })
          .and(change { ChatRoomUser.count }.by(0)
          .and(change { Message.count }.by(0)))))

      expect { invite_valid_user }.to(raise_error)
    end

    it 'Initiator ChatRoomUser#touch didnt work for some reason' do
      expect_any_instance_of(ChatRoomUser).to(receive(:touch).and_raise)

      expect(ApplicationCable::UserChannel).to_not(receive(:broadcast_to))
      expect_any_instance_of(SendChatMessagePushNotification).to_not(receive(:call))
      expect { initiate_valid_chat_room }.to(raise_error
          .and(not_change { chat_room.reload.updated_at }
          .and(not_change { chat_room.chat_room_users.find_by(user: user).reload.updated_at })
          .and(change { ChatRoomUser.count }.by(0)
          .and(change { Message.count }.by(0)))))

      expect { invite_valid_user }.to(raise_error)
    end
  end

  context 'When success' do
    it 'Creates system Message' do
      expect { invite_valid_user }.to(change { chat_room.messages.where(system: true).count }.by(1))
    end

    it 'Creates ChatRoomUser for Added User' do
      expect { invite_valid_user }.to(change { chat_room.chat_room_users.exists?(user: third_user) }.from(false).to(true))
    end

    it '#touch initiator ChatRoomUser' do
      expect { invite_valid_user }.to(change { chat_room.chat_room_users.find_by(user: user).updated_at })
    end

    it '#touch ChatRoom' do
      expect { invite_valid_user }.to(change { chat_room.reload.updated_at })
    end

    it 'Returns new ChatRoomUser record for Added User' do
      expect(invite_valid_user).to(eq(ChatRoomUser.find_by(user: third_user, chat_room: chat_room)))
    end
    it 'Broadcasts #chat event to all ChatRoomUsers through ActionCable' do
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, hash_including(type: 'chat')).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, hash_including(type: 'unread_update')).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(other_user, hash_including(type: 'chat')).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(third_user, hash_including(type: 'chat')).once)

      invite_valid_user
    end

    it 'Sends Push Notification to all ChatRoomUsers except of Initiator' do
      expect_any_instance_of(SendChatMessagePushNotification).to(receive(:call)) do |_receiver, args|
        expect([other_user.id, third_user.id]).to(include(args[:chat_room_user].user.id))
      end.twice
      invite_valid_user
    end
  end
end

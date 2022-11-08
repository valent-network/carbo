# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(LeaveChatRoom) do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:chat_room) { create(:chat_room) }

  def leave_valid_chat_room
    described_class.new.call(user.id, chat_room.id)
  end

  before do
    create(:chat_room_user, user: user, chat_room: chat_room)
    create(:chat_room_user, user: other_user, chat_room: chat_room)
    create(:message, system: true, body: 'Initiate Chat Room')
  end

  context 'Fails when' do
    it 'ChatRoom not found' do
      expect { described_class.new.call(user.id, 0) }.to(raise_error(ActiveRecord::RecordNotFound))
    end

    it 'Initiator User not found' do
      expect { described_class.new.call(0, chat_room.id) }.to(raise_error(ActiveRecord::RecordNotFound))
    end

    it 'Initiator does not have ChatRoomUser for this ChatRoom' do
      chat_room.chat_room_users.find_by(user: user).destroy
      expect { described_class.new.call(user.id, chat_room.id) }.to(raise_error(StandardError))
    end

    it 'Message was not saved for some reason' do
      expect_any_instance_of(Message).to(receive(:save!).and_raise)

      expect(ApplicationCable::UserChannel).not_to(receive(:broadcast_to))
      expect_any_instance_of(SendChatMessagePushNotification).not_to(receive(:call))
      expect { initiate_valid_chat_room }.to(raise_error(StandardError)
          .and(not_change(ChatRoom, :count)
          .and(not_change(ChatRoomUser, :count)
          .and(not_change(Message, :count)))))

      expect { leave_valid_chat_room }.to(raise_error(StandardError))
    end

    it 'ChatRoom#touch didnt work for some reason' do
      expect_any_instance_of(ChatRoom).to(receive(:touch).and_raise(StandardError))

      expect(ApplicationCable::UserChannel).not_to(receive(:broadcast_to))
      expect_any_instance_of(SendChatMessagePushNotification).not_to(receive(:call))
      expect { initiate_valid_chat_room }.to(raise_error(StandardError)
          .and(not_change(ChatRoom, :count)
          .and(not_change(ChatRoomUser, :count)
          .and(not_change(Message, :count)))))

      expect { leave_valid_chat_room }.to(raise_error(StandardError))
    end

    it 'Initiator ChatRoomUser is not destroyed for some reason' do
      expect_any_instance_of(ChatRoomUser).to(receive(:destroy).and_raise(StandardError))

      expect(ApplicationCable::UserChannel).not_to(receive(:broadcast_to))
      expect_any_instance_of(SendChatMessagePushNotification).not_to(receive(:call))
      expect { initiate_valid_chat_room }.to(raise_error(StandardError)
          .and(not_change(ChatRoom, :count)
          .and(not_change(ChatRoomUser, :count)
          .and(not_change(Message, :count)))))

      expect { leave_valid_chat_room }.to(raise_error(StandardError))
    end
  end

  context 'When success' do
    it 'destroys ChatRoomUser for Initiator user' do
      expect { leave_valid_chat_room }.to(change { chat_room.chat_room_users.exists?(user: user) }.from(true).to(false))
    end

    it 'Destroys ChatRoom if last user leaves' do
      chat_room.chat_room_users.find_by(user: other_user).destroy
      expect { leave_valid_chat_room }.to(change { ChatRoom.exists?(id: chat_room.id) }.from(true).to(false))
    end

    it 'Returns remaining ChatRoomUsers' do
      expect(leave_valid_chat_room).to(match_array([chat_room.chat_room_users.find_by(user: other_user)]))
    end

    it 'Creates system Message' do
      expect { leave_valid_chat_room }.to(change { chat_room.messages.where(system: true).count }.by(1))
    end

    it 'updates ChatRoom#updated_at' do
      expect { leave_valid_chat_room }.to(change { chat_room.reload.updated_at })
    end

    it 'Broadcasts #chat and #unread_update events to all ChatRoomUsers through ActionCable (except of Initiator ChatRoomUser)' do
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(other_user, hash_including(type: 'chat')).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(other_user, hash_including(type: 'unread_update')).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, hash_including(type: 'unread_update')).once)

      leave_valid_chat_room
    end

    it 'Sends Push Notification to all ChatRoomUsers except of Initiator' do
      expect_any_instance_of(SendChatMessagePushNotification).to(receive(:call).with(hash_including(chat_room_user: chat_room.chat_room_users.find_by(user: other_user))).once)
      leave_valid_chat_room
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(ApplicationCable::ChatRoomChannel, type: :channel) do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:chat_room) { create(:chat_room) }

  before do
    stub_connection current_user: user
    create(:chat_room_user, user: user, chat_room: chat_room)
    create(:chat_room_user, user: other_user, chat_room: chat_room)
    create(:message, system: true, body: 'Initiated Chat Room', chat_room: chat_room)
    create(:user_contact, user: user, phone_number: other_user.phone_number)
  end

  describe 'Subscribing to channel' do
    it 'confirms subscription and creates a stream' do
      subscribe(chat_room_id: chat_room.id)

      expect(subscription).to(be_confirmed)
      expect(subscription).to(have_stream_for(chat_room))
    end

    it 'updates ChatRoomUser#updated_at' do
      expect { subscribe(chat_room_id: chat_room.id) }.to(change { ChatRoomUser.find_by(user: user, chat_room: chat_room).updated_at })
    end

    it 'broadcasts read_update and unread_update to current_user' do
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, hash_including(type: 'read_update')).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, hash_including(type: 'unread_update')).once)
      subscribe(chat_room_id: chat_room.id)
    end
  end

  it 'performs #read' do
    subscribe(chat_room_id: chat_room.id)

    expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, hash_including(type: 'read_update')).once)
    expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, hash_including(type: 'unread_update')).once)

    expect { perform(:read) }.to(change { ChatRoomUser.find_by(user: user, chat_room: chat_room).updated_at })
  end

  describe 'Performing #destroy' do
    it 'destroys message' do
      subscribe(chat_room_id: chat_room.id)
      message = create(:message, chat_room: chat_room, user: user)

      expect { perform(:destroy, message: { id: message.id }) }.to(change { Message.exists?(id: message.id) }.from(true).to(false))
    end

    it 'broadcasts events to UserChannel' do
      subscribe(chat_room_id: chat_room.id)
      message = create(:message, chat_room: chat_room, user: user)

      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, hash_including(type: 'unread_update')).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, hash_including(type: 'chat')).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(user, hash_including(type: 'delete_message')).once)

      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(other_user, hash_including(type: 'chat')).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(other_user, hash_including(type: 'unread_update')).once)
      expect(ApplicationCable::UserChannel).to(receive(:broadcast_to).with(other_user, hash_including(type: 'delete_message')).once)

      perform :destroy, message: { id: message.id }
    end
  end

  it 'performs #receive' do
    subscribe(chat_room_id: chat_room.id)

    expect_any_instance_of(PostMessage).to(receive(:call).with(sender: user, message: :my))
    perform :receive, message: :my
  end
end

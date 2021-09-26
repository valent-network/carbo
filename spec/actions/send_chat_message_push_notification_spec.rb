# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(SendChatMessagePushNotification) do
  let!(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:chat_room) { create(:chat_room) }
  let(:message_body_text) { FFaker::Lorem.sentence }

  before do
    create(:chat_room_user, user: user, chat_room: chat_room)
    create(:chat_room_user, user: other_user, chat_room: chat_room)
    create(:message, system: true, body: 'Initiate Chat Room')
    create(:user_contact, user: user, phone_number: other_user.phone_number)
    user.reload.user_devices.destroy_all
    create(:user_device, user: user, os: 'ios', push_token: SecureRandom.hex)
    create(:user_device, user: user, os: 'android', push_token: SecureRandom.hex)

    allow(SendChatMessagePushNotification::APPS).to(receive(:[]).with('ios').and_return(Rpush::Apnsp8::App.create(name: 'ios', apn_key: '1', environment: 'development', apn_key_id: '1', team_id: '1', bundle_id: '1', connections: '1')))
    allow(SendChatMessagePushNotification::APPS).to(receive(:[]).with('android').and_return(Rpush::Gcm::App.create(name: 'android', auth_key: 'invalid', connections: 1)))
  end

  def send_valid_message
    message = create(:message, chat_room: chat_room, user: other_user, body: message_body_text)
    chat_room_user = chat_room.chat_room_users.find_by(user: user)
    described_class.new.call(message: message, chat_room_user: chat_room_user)
  end

  def send_valid_system_message
    message = create(:message, chat_room: chat_room, system: true, body: message_body_text)
    chat_room_user = chat_room.chat_room_users.find_by(user: user)
    described_class.new.call(message: message, chat_room_user: chat_room_user)
  end

  context 'When success' do
    it 'Creates system Message without ChatRoomUser name when' do
      title = chat_room.ad.details.slice('maker', 'model', 'year').values.join(' ')
      expect(Rpush::Gcm::Notification).to(receive(:create).with(hash_including(data: hash_including(message: message_body_text))))
      expect(Rpush::Apns::Notification).to(receive(:create).with(hash_including(alert: "#{title}\n#{message_body_text}")))

      send_valid_system_message
    end

    it 'Returns UserDevices where Push Notifications were sent to' do
      expect(send_valid_message).to(match_array(user.reload.user_devices))
    end

    describe 'Rpush::Apns::Notification' do
      it 'sent with default sound' do
        expect(Rpush::Apns::Notification).to(receive(:create).with(hash_including(sound: 'default')))
        send_valid_message
      end

      it 'sent for each iOS device with #push_token' do
        expect(Rpush::Apns::Notification).to(receive(:create).with(hash_including(device_token: user.user_devices.where(os: 'ios').first.push_token)))
        send_valid_message
      end

      it 'sent with alert containing chat title and message body' do
        title = chat_room.ad.details.slice('maker', 'model', 'year').values.join(' ')
        message_body = "#{chat_room.chat_room_users.find_by(user: other_user).name}: #{message_body_text}"

        expect(Rpush::Apns::Notification).to(receive(:create).with(hash_including(alert: "#{title}\n#{message_body}")))
        send_valid_message
      end

      it 'sent with badge equal to unread Message count' do
        expect(Rpush::Apns::Notification).to(receive(:create).with(hash_including(badge: 1)))
        send_valid_message
      end

      it 'sent with data containing chat_room_id' do
        expect(Rpush::Apns::Notification).to(receive(:create).with(hash_including(data: hash_including(chat_room_id: chat_room.id))))
        send_valid_message
      end
    end

    describe 'Rpush::Gcm::Notification' do
      it 'sent with high priority' do
        expect(Rpush::Gcm::Notification).to(receive(:create).with(hash_including(priority: 'high')))
        send_valid_message
      end

      it 'sent for each Android device with #push_token' do
        expect(Rpush::Gcm::Notification).to(receive(:create).with(hash_including(registration_ids: [user.user_devices.where(os: 'android').first.push_token])))
        send_valid_message
      end

      it 'sent with data containing chat_room_id' do
        expect(Rpush::Gcm::Notification).to(receive(:create).with(hash_including(data: hash_including(chat_room_id: chat_room.id))))
        send_valid_message
      end

      it 'sent with data containing unread_count' do
        expect(Rpush::Gcm::Notification).to(receive(:create).with(hash_including(data: hash_including(unread_count: 1))))
        send_valid_message
      end

      it 'sent with data containing title' do
        title = chat_room.ad.details.slice('maker', 'model', 'year').values.join(' ')
        expect(Rpush::Gcm::Notification).to(receive(:create).with(hash_including(data: hash_including(title: title))))
        send_valid_message
      end

      it 'sent with data containing message body' do
        message_body = "#{chat_room.chat_room_users.find_by(user: other_user).name}: #{message_body_text}"
        expect(Rpush::Gcm::Notification).to(receive(:create).with(hash_including(data: hash_including(message: message_body))))
        send_valid_message
      end
    end
  end
end

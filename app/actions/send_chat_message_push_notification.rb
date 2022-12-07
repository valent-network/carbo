# frozen_string_literal: true
class SendChatMessagePushNotification
  APPS = {
    'ios' => Rpush::Client::ActiveRecord::Apnsp8::App.find_by_name('ios'),
    'android' => Rpush::Client::ActiveRecord::Gcm::App.find_by_name('android'),
  }

  def call(message:, chat_room_user:)
    message_body = message.user ? "#{message.chat_room.chat_room_users.find_by(user: message.user).name}: #{message.body}" : message.body
    ad = chat_room_user.chat_room.ad
    unread_count = Message.unread_messages_for(chat_room_user.user_id).count
    user_devices_to_receive_notification = chat_room_user.user.user_devices.where.not(push_token: ['', nil]).where(os: %w[ios android])
    user_devices_to_receive_notification.each do |device|
      app = APPS[device.os]
      title = chat_room_user.chat_room.system? ? "#{I18n.t('recario', locale: device.locale)} 🌀" : "#{ad.details['maker']} #{ad.details['model']} #{ad.details['year']}"

      case device.os
      when 'ios'
        notification_params = {
          app: app,
          device_token: device.push_token,
          alert: "#{title}\n#{message_body}",
          sound: 'default',
          badge: unread_count,
          data: { chat_room_id: chat_room_user.chat_room_id, notification_action: 'open_chat_room' },
        }

        Rpush::Client::ActiveRecord::Apnsp8::Notification.create!(notification_params)
      when 'android'
        notification_params = {
          app: app,
          registration_ids: [device.push_token],
          priority: 'high',
          data: {
            notification_action: 'open_chat_room',
            chat_room_id: chat_room_user.chat_room_id,
            unread_count: unread_count,
            title: title,
            message: message_body,
          },
          notification: {
            title: title,
            body: message_body,
          },
        }

        Rpush::Client::ActiveRecord::Gcm::Notification.create!(notification_params)
      end
    end

    user_devices_to_receive_notification
  end
end

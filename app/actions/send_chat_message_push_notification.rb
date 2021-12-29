# frozen_string_literal: true
class SendChatMessagePushNotification
  APPS = {
    'ios' => Rpush::Client::ActiveRecord::Apnsp8::App.find_by_name('ios'),
    'android' => Rpush::Gcm::App.find_by_name('android'),
  }

  def call(message:, chat_room_user:)
    message_body = message.user ? "#{message.chat_room.chat_room_users.find_by(user: message.user).name}: #{message.body}" : message.body
    ad = chat_room_user.chat_room.ad
    title = chat_room_user.chat_room.system? ? 'Рекарио 🌀' : "#{ad.details['maker']} #{ad.details['model']} #{ad.details['year']}"
    unread_count = Message.unread_messages_for(chat_room_user.user_id).count
    user_devices_to_receive_notification = chat_room_user.user.user_devices.where.not(push_token: ['', nil]).where(os: %w[ios android])

    user_devices_to_receive_notification.each do |device|
      app = APPS[device.os]

      case device.os
      when 'ios'
        alert = device.build_version.to_s.split('.').last.to_i >= 9 ? "#{title}\n#{message_body}" : "Новое сообщение\nЧтобы прочитать, нужно обновить приложение"
        notification_params = {
          app: app,
          device_token: device.push_token,
          alert: alert,
          sound: 'default',
          badge: unread_count,
          data: { chat_room_id: chat_room_user.chat_room_id },
        }

        Rpush::Apns::Notification.create(notification_params)
      when 'android'
        notification_params = {
          app: app,
          registration_ids: [device.push_token],
          priority: 'high',
          data: {
            chat_room_id: chat_room_user.chat_room_id,
            unread_count: unread_count,
            title: device.build_version.to_i >= 26 ? title : 'Новое сообщение',
            message: device.build_version.to_i >= 26 ? message_body : 'Чтобы прочитать, нужно обновить приложение',
          },
        }

        Rpush::Gcm::Notification.create(notification_params)
      end
    end

    user_devices_to_receive_notification
  end
end

# frozen_string_literal: true

class SystemMessageAdminNotification
  def call(admin:, message_body:, sender_name:, chat_room_id:)
    devices = admin.user_devices.where.not(push_token: ["", nil]).where(os: %w[ios android])
    devices.each do |device|
      title = "#{I18n.t("support_request", locale: device.locale)} 🌀 #{sender_name}"

      case device.os
      when "ios"
        notification_params = {
          app: Rpush::Client::ActiveRecord::Apnsp8::App.find_by_name("ios"),
          device_token: device.push_token,
          alert: "#{title}\n#{message_body}",
          sound: "default",
          data: {chat_room_id: chat_room_id, notification_action: "open_admin_chat_room"}
        }

        Rpush::Client::ActiveRecord::Apnsp8::Notification.create!(notification_params)
      when "android"
        notification_params = {
          app: Rpush::Client::ActiveRecord::Gcm::App.find_by_name("android"),
          registration_ids: [device.push_token],
          priority: "high",
          data: {
            notification_action: "open_admin_chat_room",
            chat_room_id: chat_room_id,
            title: title,
            message: message_body
          },
          notification: {
            title: title,
            body: message_body
          }
        }

        Rpush::Client::ActiveRecord::Gcm::Notification.create!(notification_params)
      end
    end

    devices
  end
end

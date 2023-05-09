# frozen_string_literal: true

class SendSystemMessageToAdmins
  def call(message_text)
    sender = SendSystemMessageToChatRoom.new

    User.where(admin: true).each do |user|
      sender.call(user_id: user.id, message_text: message_text)
    end
  end
end

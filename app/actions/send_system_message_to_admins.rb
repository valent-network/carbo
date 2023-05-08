# frozen_string_literal: true

class SendSystemMessageToAdmins
  ADMIN_USERS_IDS = ENV["ADMIN_USERS_IDS"].to_s.split

  def call(message_text)
    sender = SendSystemMessageToChatRoom.new

    ADMIN_USERS_IDS.each do |user_id|
      user = User.find(user_id)
      sender.call(user_id: user.id, message_text: message_text)
    end
  end
end

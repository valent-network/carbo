# frozen_string_literal: true
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar, :phone_number, :user_contacts_count, :unread_messages_count

  def avatar
    object.avatar.url
  end

  def phone_number
    object.phone_number.to_s
  end

  def user_contacts_count
    object.user_contacts.count
  end

  def unread_messages_count
    Message.unread_messages_for(object.id).count
  end
end

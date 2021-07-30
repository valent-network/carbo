# frozen_string_literal: true
class ProfileUserSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar, :phone_number, :refcode, :referrer, :user_contacts_count, :unread_messages_count

  # TODO: name attribute should be considered private. So that when privacy
  # policy will be implemented for User through Settings, name could be hidden
  # from users who have me in their phone book but I don't have them in mine

  def avatar
    object.avatar.url
  end

  def phone_number
    object.phone_number.to_s
  end

  def referrer
    {
      refcode: object.referrer_refcode,
      name: object.referrer_name,
      contact_name: object.referrer_contact&.name,
      phone: object.referrer_contact&.phone_number&.to_s,
    }
  end
end

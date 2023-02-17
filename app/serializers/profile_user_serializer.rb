# frozen_string_literal: true
class ProfileUserSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar, :phone_number, :refcode, :referrer, :user_contacts_count, :unread_messages_count, :unread_admin_messages_count, :admin

  # TODO: name attribute should be considered private. So that when privacy
  # policy will be implemented for User through Settings, name could be hidden
  # from users who have me in their phone book but I don't have them in mine

  def avatar
    object.avatar.url
  end

  def phone_number
    object.phone_number.to_s
  end

  def unread_admin_messages_count
    object.admin? ? Message.unread_system_messages.values.sum : 0
  end

  def referrer
    return unless @instance_options[:current_user]

    ref_c = object.referrer_contacts.detect { |rc| rc.user_id == @instance_options[:current_user].id }
    {
      refcode: object.referrer_refcode,
      name: object.referrer_name,
      contact_name: ref_c&.name,
      phone: ref_c&.phone_number&.to_s,
      avatar: User.select(:id, :avatar).find_by(id: object.referrer_id)&.avatar&.url,
    }
  end
end

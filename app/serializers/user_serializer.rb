# frozen_string_literal: true
class UserSerializer < ActiveModel::Serializer
  attributes :name, :avatar, :phone_number

  def avatar
    object.avatar.url
  end

  def phone_number
    object.phone_number.to_s
  end
end

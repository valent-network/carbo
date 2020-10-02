# frozen_string_literal: true
class UserSerializer < ActiveModel::Serializer
  attributes :name, :avatar

  def avatar
    object.avatar.url
  end
end

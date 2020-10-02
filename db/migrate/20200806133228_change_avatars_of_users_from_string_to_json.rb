# frozen_string_literal: true
class ChangeAvatarsOfUsersFromStringToJson < ActiveRecord::Migration[6.0]
  def change
    remove_column(:users, :avatar, :string)
    add_column(:users, :avatar, :json)
  end
end

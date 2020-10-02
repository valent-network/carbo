# frozen_string_literal: true
class AddOsAndPushTokenToUserDevices < ActiveRecord::Migration[6.0]
  def change
    add_column(:user_devices, :os, :string)
    add_column(:user_devices, :push_token, :string)
  end
end

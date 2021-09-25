# frozen_string_literal: true
class AddSessionStartedAtToUserDevices < ActiveRecord::Migration[6.1]
  def change
    add_column(:user_devices, :session_started_at, :datetime)
  end
end

# frozen_string_literal: true
class CreateUserDeviceStats < ActiveRecord::Migration[6.0]
  def change
    create_table(:user_device_stats) do |t|
      t.integer(:user_devices_appeared_count, null: false)
      t.timestamps
    end
  end
end

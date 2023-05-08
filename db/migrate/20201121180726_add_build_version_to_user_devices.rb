# frozen_string_literal: true

class AddBuildVersionToUserDevices < ActiveRecord::Migration[6.0]
  def change
    add_column(:user_devices, :build_version, :string)
  end
end

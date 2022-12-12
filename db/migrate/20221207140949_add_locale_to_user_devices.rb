# frozen_string_literal: true
class AddLocaleToUserDevices < ActiveRecord::Migration[7.0]
  def change
    add_column(:user_devices, :locale, :string)
  end
end

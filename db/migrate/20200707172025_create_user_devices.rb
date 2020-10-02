# frozen_string_literal: true
class CreateUserDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :user_devices do |t|
      t.belongs_to(:user, null: false)

      t.string(:device_id, null: false)
      t.string(:access_token, null: false)

      t.timestamps
    end

    add_index(:user_devices, :access_token, unique: true)
    add_index(:user_devices, :device_id, unique: true)

    add_foreign_key(:user_devices, :users, on_delete: :cascade)
  end
end

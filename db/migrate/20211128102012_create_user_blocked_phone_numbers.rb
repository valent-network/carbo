# frozen_string_literal: true
class CreateUserBlockedPhoneNumbers < ActiveRecord::Migration[6.1]
  def change
    create_table(:user_blocked_phone_numbers) do |t|
      t.belongs_to(:user, null: false, index: false)
      t.belongs_to(:phone_number, null: false, index: false)
    end

    add_index(:user_blocked_phone_numbers, [:user_id, :phone_number_id], unique: true)
    add_foreign_key(:user_blocked_phone_numbers, :users)
    add_foreign_key(:user_blocked_phone_numbers, :phone_numbers)
  end
end

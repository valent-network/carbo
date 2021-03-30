# frozen_string_literal: true
class CreateUserContacts < ActiveRecord::Migration[6.0]
  def change
    create_table(:user_contacts) do |t|
      t.belongs_to(:user, null: false)
      t.belongs_to(:phone_number, null: false, index: false)

      t.string(:name, null: false, limit: 100)
    end

    add_index(:user_contacts, %w[phone_number_id user_id], unique: true)

    add_foreign_key(:user_contacts, :users, on_delete: :cascade)
    add_foreign_key(:user_contacts, :phone_numbers, on_delete: :cascade)
  end
end

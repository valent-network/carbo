# frozen_string_literal: true
class AdjustUserContactsIndexes < ActiveRecord::Migration[7.0]
  def up
    remove_index(:user_contacts, :user_id)
    remove_index(:user_contacts, [:phone_number_id, :user_id])
    remove_index(:user_contacts, name: :index_user_contacts_on_phone_number_id_and_user_id_include_name)
    add_index(:user_contacts, :phone_number_id)
  end

  def down
    add_index(:user_contacts, :user_id)
    add_index(:user_contacts, [:phone_number_id, :user_id], unique: true)
    execute('CREATE INDEX index_user_contacts_on_phone_number_id_and_user_id_include_name ON user_contacts(phone_number_id, user_id) INCLUDE(name)')
    remove_index(:user_contacts, :phone_number_id)
  end
end

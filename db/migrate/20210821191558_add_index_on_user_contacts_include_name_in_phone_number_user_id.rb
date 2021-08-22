class AddIndexOnUserContactsIncludeNameInPhoneNumberUserId < ActiveRecord::Migration[6.1]
  def up
    execute('CREATE INDEX index_user_contacts_on_phone_number_id_and_user_id_include_name ON user_contacts(phone_number_id, user_id) INCLUDE(name)')
  end

  def down
    remove_index :user_contacts, name: :index_user_contacts_on_phone_number_id_and_user_id_include_name
  end
end

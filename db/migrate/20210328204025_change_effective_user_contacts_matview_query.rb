# frozen_string_literal: true

class ChangeEffectiveUserContactsMatviewQuery < ActiveRecord::Migration[6.1]
  def up
    execute("DROP MATERIALIZED VIEW effective_user_contacts")
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW effective_user_contacts AS
        SELECT user_contacts.user_id, user_contacts.phone_number_id
        FROM user_contacts
        JOIN users ON users.phone_number_id = user_contacts.phone_number_id
        UNION
        SELECT user_contacts.user_id, user_contacts.phone_number_id
        FROM user_contacts
        WHERE user_contacts.phone_number_id IN (SELECT DISTINCT effective_ads.phone_number_id FROM effective_ads)
      WITH DATA
    SQL

    add_index(:effective_user_contacts, :phone_number_id)
    add_index(:effective_user_contacts, [:phone_number_id, :user_id], unique: true)
  end

  def down
    execute("DROP MATERIALIZED VIEW effective_user_contacts")
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW effective_user_contacts AS
        SELECT user_contacts.user_id, user_contacts.phone_number_id
        FROM user_contacts
        JOIN users ON users.phone_number_id = user_contacts.phone_number_id
      WITH DATA
    SQL

    add_index(:effective_user_contacts, :phone_number_id)
    add_index(:effective_user_contacts, [:phone_number_id, :user_id], unique: true)
  end
end

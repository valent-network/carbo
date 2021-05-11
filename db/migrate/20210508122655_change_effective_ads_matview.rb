# frozen_string_literal: true
class ChangeEffectiveAdsMatview < ActiveRecord::Migration[6.1]
  def up
    execute('DROP MATERIALIZED VIEW effective_ads CASCADE')
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW effective_ads AS (
        SELECT DISTINCT ads.id, ads.phone_number_id, ads.price
        FROM ads
        JOIN user_contacts ON user_contacts.phone_number_id = ads.phone_number_id
        WHERE ads.deleted = 'F'
      )
      WITH DATA
    SQL

    add_index(:effective_ads, :id, unique: true, order: { id: :desc })
    add_index(:effective_ads, %w[phone_number_id id], order: { id: :desc })
    add_index(:effective_ads, :price)

    execute(<<~SQL)
      CREATE MATERIALIZED VIEW effective_user_contacts AS
        SELECT user_contacts.*
        FROM user_contacts
        JOIN users ON users.phone_number_id = user_contacts.phone_number_id
        UNION
        SELECT user_contacts.*
        FROM user_contacts
        WHERE user_contacts.phone_number_id IN (SELECT DISTINCT effective_ads.phone_number_id FROM effective_ads)
      WITH DATA
    SQL

    add_index(:effective_user_contacts, :phone_number_id)
    add_index(:effective_user_contacts, [:phone_number_id, :user_id], unique: true)
  end

  def down
    execute('DROP MATERIALIZED VIEW effective_ads CASCADE')
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW effective_ads AS (
        SELECT DISTINCT ads.id, ads.phone_number_id, ads.price, ads.details
        FROM ads
        JOIN user_contacts ON user_contacts.phone_number_id = ads.phone_number_id
        WHERE ads.deleted = 'F' AND ads.updated_at >= NOW() - INTERVAL '2 months'
      )
      WITH DATA
    SQL

    add_index(:effective_ads, :id, unique: true, order: { id: :desc })
    add_index(:effective_ads, %w[phone_number_id id], order: { id: :desc })
    add_index(:effective_ads, :price)

    execute(<<~SQL)
      CREATE MATERIALIZED VIEW effective_user_contacts AS
        SELECT user_contacts.*
        FROM user_contacts
        JOIN users ON users.phone_number_id = user_contacts.phone_number_id
        UNION
        SELECT user_contacts.*
        FROM user_contacts
        WHERE user_contacts.phone_number_id IN (SELECT DISTINCT effective_ads.phone_number_id FROM effective_ads)
      WITH DATA
    SQL

    add_index(:effective_user_contacts, :phone_number_id)
    add_index(:effective_user_contacts, [:phone_number_id, :user_id], unique: true)
  end
end

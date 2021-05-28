# frozen_string_literal: true
class AddAdOptionsDetailsToEffectiveAds < ActiveRecord::Migration[6.1]
  def up
    execute('DROP MATERIALIZED VIEW effective_user_contacts')
    execute('DROP MATERIALIZED VIEW effective_ads')

    execute(<<~SQL)
            CREATE MATERIALIZED VIEW effective_ads AS (
              SELECT ads.id,
                    ads.phone_number_id,
                    ads.price,
                    (options->>'year')::smallint AS year,
                    (
                      (options->>'maker') || ' ' || (options->>'model') || ' ' || (options->>'year')
                    ) AS search_query,
                    options->>'fuel' AS fuel,
                    options->>'wheels' AS wheels,
                    options->>'gear' AS gear,
                    options->>'carcass' AS carcass
      #{'              '}
              FROM (
                SELECT ads.id,
                       ads.phone_number_id,
                       ads.price,
                       JSON_OBJECT(ARRAY_AGG(array[ad_option_types.name, ad_option_values.value])) AS options
                FROM (
                  SELECT DISTINCT ads.id,
                                  ads.phone_number_id,
                                  ads.price
                  FROM ads
                  JOIN user_contacts ON user_contacts.phone_number_id = ads.phone_number_id
                  WHERE ads.deleted = 'F'
                ) AS ads
                JOIN ad_options on ad_options.ad_id = ads.id
                JOIN ad_option_types on ad_options.ad_option_type_id = ad_option_types.id
                JOIN ad_option_values on ad_options.ad_option_value_id = ad_option_values.id
                GROUP BY ads.id, ads.phone_number_id, ads.price
              ) AS ads
            )
    SQL

    add_index(:effective_ads, :id, unique: true, order: { id: :desc })
    add_index(:effective_ads, %w[phone_number_id id], order: { id: :desc })
    add_index(:effective_ads, :search_query, using: :gin, opclass: { title: :gin_trgm_ops })

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

    add_index(:effective_user_contacts, [:phone_number_id, :user_id], unique: true)
  end

  def down
    execute('DROP MATERIALIZED VIEW effective_user_contacts')
    execute('DROP MATERIALIZED VIEW effective_ads')

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
end

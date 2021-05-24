# frozen_string_literal: true
class ChangeColumnTypesToOptimizeMemory < ActiveRecord::Migration[6.1]
  def up
    execute('DROP MATERIALIZED VIEW ads_grouped_by_maker_model_year')
    execute('DROP MATERIALIZED VIEW effective_user_contacts')
    execute('DROP MATERIALIZED VIEW effective_ads')

    change_column(:ad_option_values, :id, 'integer')

    change_column(:ad_options, :ad_id, 'integer')
    change_column(:ad_options, :ad_option_type_id, 'smallint')
    change_column(:ad_options, :ad_option_value_id, 'integer')

    change_column(:user_contacts, :id, 'integer')
    change_column(:user_contacts, :user_id, 'integer')
    change_column(:user_contacts, :phone_number_id, 'integer')

    change_column(:ads, :id, 'integer')
    change_column(:ads, :phone_number_id, 'integer')

    execute(<<~SQL)
      CREATE MATERIALIZED VIEW ads_grouped_by_maker_model_year AS (
        SELECT maker,
               model,
               year,
               MIN(price) AS min_price,
               ROUND(AVG(price) / 100) * 100 AS avg_price,
               MAX(price) AS max_price
        FROM (
          SELECT ads.id,
                 price,
                 MAX(ad_option_values.value) FILTER (WHERE ad_options.ad_option_type_id = 6) AS maker,
                 MAX(ad_option_values.value) FILTER (WHERE ad_options.ad_option_type_id = 7) AS model,
                 MAX(ad_option_values.value) FILTER (WHERE ad_options.ad_option_type_id = 4) AS year
          FROM ads
          JOIN ad_options ON ads.id = ad_options.ad_id AND ad_options.ad_option_type_id IN (4,6,7)
          JOIN ad_option_values ON ad_option_values.id = ad_options.ad_option_value_id
          WHERE deleted = 'F'
          GROUP BY ads.id
        ) AS ads
        GROUP BY maker, model, year
        HAVING COUNT(ads) >= 5
        ORDER BY maker, model, year
      )
    SQL
    add_index(:ads_grouped_by_maker_model_year, %w[min_price max_price], name: 'search_budget_index')

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
    execute('DROP MATERIALIZED VIEW ads_grouped_by_maker_model_year')
    execute('DROP MATERIALIZED VIEW effective_user_contacts')
    execute('DROP MATERIALIZED VIEW effective_ads')

    change_column(:ad_option_values, :id, 'bigint')

    change_column(:ad_options, :ad_id, 'bigint')
    change_column(:ad_options, :ad_option_type_id, 'bigint')
    change_column(:ad_options, :ad_option_value_id, 'bigint')

    change_column(:user_contacts, :id, 'bigint')
    change_column(:user_contacts, :user_id, 'bigint')
    change_column(:user_contacts, :phone_number_id, 'bigint')

    change_column(:ads, :id, 'bigint')
    change_column(:ads, :phone_number_id, 'bigint')

    execute(<<~SQL)
      CREATE MATERIALIZED VIEW ads_grouped_by_maker_model_year AS (
        SELECT maker,
               model,
               year,
               MIN(price) AS min_price,
               ROUND(AVG(price) / 100) * 100 AS avg_price,
               MAX(price) AS max_price
        FROM (
          SELECT ads.id,
                 price,
                 MAX(ad_option_values.value) FILTER (WHERE ad_options.ad_option_type_id = 6) AS maker,
                 MAX(ad_option_values.value) FILTER (WHERE ad_options.ad_option_type_id = 7) AS model,
                 MAX(ad_option_values.value) FILTER (WHERE ad_options.ad_option_type_id = 4) AS year
          FROM ads
          JOIN ad_options ON ads.id = ad_options.ad_id AND ad_options.ad_option_type_id IN (4,6,7)
          JOIN ad_option_values ON ad_option_values.id = ad_options.ad_option_value_id
          WHERE deleted = 'F'
          GROUP BY ads.id
        ) AS ads
        GROUP BY maker, model, year
        HAVING COUNT(ads) >= 5
        ORDER BY maker, model, year
      )
    SQL
    add_index(:ads_grouped_by_maker_model_year, %w[min_price max_price], name: 'search_budget_index')

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

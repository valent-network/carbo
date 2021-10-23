# frozen_string_literal: true
class AdjustEffectiveAds < ActiveRecord::Migration[6.1]
  def up
    execute('DROP MATERIALIZED VIEW dashboard_stats')
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
        FROM (
          SELECT ads.id,
                 ads.phone_number_id,
                 ads.price,
                 JSON_OBJECT(ARRAY_AGG(array[ad_option_types.name, ad_option_values.value])) AS options
          FROM known_ads AS ads
          JOIN ad_options on ad_options.ad_id = ads.id AND ad_options.ad_option_type_id IN (1,2,4,6,7,9,11)
          JOIN ad_option_types on ad_options.ad_option_type_id = ad_option_types.id
          JOIN ad_option_values on ad_options.ad_option_value_id = ad_option_values.id
          GROUP BY ads.id, ads.phone_number_id, ads.price
        ) AS ads
      )
    SQL

    add_index(:effective_ads, :id, unique: true, order: { id: :desc })
    add_index(:effective_ads, %w[phone_number_id id], order: { id: :desc })
    add_index(:effective_ads, :search_query, using: :gin, opclass: { title: :gin_trgm_ops })

    execute(CREATE_MATERIALIZED_VIEW_DASHBOARD_STATS_SQL)
  end

  def down
    execute('DROP MATERIALIZED VIEW dashboard_stats')
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

    execute(CREATE_MATERIALIZED_VIEW_DASHBOARD_STATS_SQL)
  end

  CREATE_MATERIALIZED_VIEW_DASHBOARD_STATS_SQL = <<~SQL
    CREATE MATERIALIZED VIEW dashboard_stats AS (
      SELECT
        (NOW()) AS updated_at,
        (SELECT COUNT(id) FROM users) AS users_count,
        (SELECT COUNT(id) FROM users WHERE NOT (EXISTS (SELECT 1 FROM user_contacts WHERE user_contacts.user_id = users.id))) AS users_with_no_contacts_count,
        (SELECT COUNT(id) FROM users WHERE NOT (EXISTS (SELECT 1 FROM user_connections WHERE user_connections.user_id = users.id AND user_connections.friend_id != users.id))) AS users_with_no_connections_count,
        (SELECT COUNT(id) FROM users WHERE users.referrer_id IS NOT NULL) AS users_with_referrer_count,
        (SELECT COUNT(id) FROM user_connections) AS user_connections_count,
        (SELECT COUNT(id) FROM user_devices) AS user_devices_count,
        (SELECT COUNT(id) FROM ads) AS ads_count,
        (SELECT COUNT(id) FROM effective_ads) AS effective_ads_count,
        (SELECT COUNT(id) FROM ads WHERE deleted = FALSE) AS active_ads_count,
        (SELECT COUNT(id) FROM messages) AS messages_count,
        (SELECT COUNT(id) FROM chat_rooms) AS chat_rooms_count,
        (SELECT COUNT(id) FROM phone_numbers) AS phone_numbers_count,
        (SELECT COUNT(id) FROM user_contacts) AS user_contacts_count,
        (SELECT COUNT(DISTINCT phone_number_id) FROM user_contacts) AS uniq_user_contacts_count,
        (SELECT COUNT(id) FROM ads WHERE ads.phone_number_id IN (SELECT phone_number_id FROM user_contacts)) AS known_ads_count,
        (SELECT COUNT(id) FROM ads WHERE ads.phone_number_id IN (SELECT phone_number_id FROM user_contacts) AND updated_at < (NOW() - INTERVAL '24 hours')) AS syncing_ads_count,
        (select created_at from users order by id desc limit 1) AS last_user_created_at,
        (select created_at from ads order by id desc limit 1) AS last_ad_created_at,
        (select created_at from messages order by created_at desc limit 1) AS last_message_created_at,
        (select created_at from chat_rooms order by created_at desc limit 1) AS last_chat_room_created_at,
        (select created_at from ads where id = (SELECT MAX(id) FROM effective_ads) limit 1) AS last_effective_ad_created_at,
        (
          SELECT user_devices.updated_at
          FROM user_devices
          JOIN users ON users.id = user_devices.user_id
          WHERE users.id != 1
          ORDER BY user_devices.updated_at
          DESC LIMIT 1
        ) AS last_user_device_updated_at,
        (
          SELECT JSON_AGG(t)
          FROM (
            SELECT COUNT(*) AS count, date(created_at) AS date
            FROM events
            WHERE events.name = 'invited_user' AND created_at > (NOW() - INTERVAL '1 month')
            GROUP BY date(created_at)
            ORDER BY date(created_at)
          ) AS t
        ) AS invited_users_chart_data,
        (
            SELECT JSON_AGG(t)
            FROM (
              SELECT COUNT(*) AS count, date(created_at) AS date
              FROM events
              WHERE events.name = 'visited_ad' AND created_at > (NOW() - INTERVAL '1 month')
              GROUP BY date(created_at)
              ORDER BY date(created_at)
            ) AS t
        ) AS visited_ad_chart_data,
        (
          SELECT JSON_AGG(t)
          FROM (
            SELECT COUNT(DISTINCT user_id) AS count, date(created_at) AS date
            FROM events
            WHERE events.name != 'snapshot_user_visibility' AND created_at > (NOW() - INTERVAL '1 month')
            GROUP BY date(created_at)
          ) AS t
        ) AS user_activity_chart_data,
        (
          SELECT JSON_AGG(t)
          FROM (
            SELECT COUNT(*) AS count, date(created_at) AS date
            FROM users
            WHERE created_at > (NOW() - INTERVAL '1 month')
            GROUP BY date(created_at)
          ) AS t
        ) AS user_registrations_chart_data,
        (
        SELECT JSON_AGG(t)
        FROM (
          SELECT COUNT(*) AS count, date(messages.created_at) AS date
          FROM messages
          JOIN chat_rooms ON chat_rooms.id = messages.chat_room_id
          WHERE messages.created_at > (NOW() - INTERVAL '1 month') AND chat_rooms.system = FALSE
          GROUP BY date(messages.created_at)
        ) AS t
        ) AS messages_chart_data,
        (
          SELECT JSON_AGG(t)
          FROM (
            SELECT COUNT(*) AS count, user_devices.os AS os_title
            FROM user_devices
            GROUP BY user_devices.os
          ) AS t

        ) AS user_devices_os_data,
        (
          SELECT JSON_AGG(tt) FROM
          (
            SELECT users.refcode, t.count
            FROM (
              SELECT referrer_id, COUNT(referrer_id)
              FROM users
              WHERE referrer_id IS NOT NULL
              GROUP BY referrer_id
              HAVING COUNT(referrer_id) > 5
              ORDER BY COUNT(referrer_id) DESC
            ) AS t
            JOIN users ON users.id = t.referrer_id
          ) AS tt
        ) AS referrers_top,
        (
          SELECT JSON_AGG(t)
          FROM (
            SELECT COUNT(DISTINCT user_id) AS count, to_char(date(created_at), 'YYYY-MM') AS date
            FROM events
            WHERE events.name != 'snapshot_user_visibility' AND created_at > (NOW() - INTERVAL '6 months')
            GROUP BY to_char(date(created_at), 'YYYY-MM')
          ) AS t
        ) AS mau_chart_data
    )
  SQL
end

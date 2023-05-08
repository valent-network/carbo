# frozen_string_literal: true

class RemoveDemoPhoneNumbersFromPromoEventsAndChangeColNames < ActiveRecord::Migration[6.1]
  def up
    execute("DROP MATERIALIZED VIEW promo_events_matview")
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW promo_events_matview AS (
        SELECT ROW_NUMBER() OVER(ORDER BY events.created_at) AS id,
              events.id AS event_id,
              users.refcode,
              REGEXP_REPLACE(phone_numbers.full_number, '^(\\d{2})(\\d{3})(\\d{4})$', '+380\\1\\2****', 'g') AS full_phone_number_masked,
              events.name,
              events.created_at
        FROM events
        JOIN users ON events.user_id = users.id
        JOIN phone_numbers ON users.phone_number_id = phone_numbers.id
        WHERE events.name IN ('sign_up', 'set_referrer', 'invited_user') AND
              users.phone_number_id NOT IN (SELECT phone_number_id FROM demo_phone_numbers)
        ORDER BY events.created_at DESC
      )
    SQL

    add_index(:promo_events_matview, :id, unique: true)
    add_index(:promo_events_matview, :refcode)
  end

  def down
    execute("DROP MATERIALIZED VIEW promo_events_matview")
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW promo_events_matview AS (
        SELECT ROW_NUMBER() OVER(ORDER BY events.created_at) AS id,
              users.refcode,
              REGEXP_REPLACE(phone_numbers.full_number, '^(\\d{2})(\\d{3})(\\d{4})$', '+38 0\\1 \\2-**-**', 'g') AS full_phone_number,
              events.name,
              events.created_at
        FROM events
        JOIN users ON events.user_id = users.id
        JOIN phone_numbers ON users.phone_number_id = phone_numbers.id
        WHERE events.name IN ('sign_up', 'set_referrer', 'invited_user')
        ORDER BY events.created_at
      )
    SQL

    add_index(:promo_events_matview, :id, unique: true)
    add_index(:promo_events_matview, :refcode)
  end
end

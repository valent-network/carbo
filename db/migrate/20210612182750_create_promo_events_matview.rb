# frozen_string_literal: true
class CreatePromoEventsMatview < ActiveRecord::Migration[6.1]
  def up
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW promo_events_matview AS (
      SELECT ROW_NUMBER() OVER(ORDER BY events.created_at) AS id,
             events.user_id,
             events.name,
             events.data,
             events.created_at
      FROM events
      WHERE events.name IN ('sign_up', 'set_referrer', 'invited_user')
      ORDER BY events.created_at
      )
    SQL

    add_index(:promo_events_matview, :id, unique: true)
  end

  def down
    execute('DROP MATERIALIZED VIEW promo_events_matview')
  end
end

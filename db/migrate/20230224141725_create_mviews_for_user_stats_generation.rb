# frozen_string_literal: true
class CreateMviewsForUserStatsGeneration < ActiveRecord::Migration[7.0]
  def up
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW active_known_ads AS
      SELECT id, city_id, phone_number_id
      FROM ads
      WHERE ads.deleted = FALSE AND ads.phone_number_id IN (SELECT phone_number_id FROM user_contacts)
    SQL
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW users_known_ads AS
      SELECT user_contacts.user_id, ads.id
      FROM active_known_ads AS ads
      JOIN user_contacts ON user_contacts.phone_number_id = ads.phone_number_id
      GROUP BY user_contacts.user_id, ads.id
    SQL
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW users_known_users AS
      SELECT user_connections.user_id, user_connections.connection_id
      FROM user_connections
      GROUP BY user_connections.user_id, user_connections.connection_id
    SQL
  end

  def down
    execute('DROP MATERIALIZED VIEW users_known_ads')
    execute('DROP MATERIALIZED VIEW active_known_ads')
    execute('DROP MATERIALIZED VIEW users_known_users')
  end
end

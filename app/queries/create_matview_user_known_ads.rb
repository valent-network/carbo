# frozen_string_literal: true
class CreateMatviewUserKnownAds
  def call
    <<~SQL
      CREATE MATERIALIZED VIEW user_known_ads AS
      SELECT DISTINCT users.id AS user_id, ads.id AS ad_id
      FROM users
      JOIN user_connections ON user_connections.user_id = users.id
      JOIN user_contacts ON user_contacts.user_id = user_connections.connection_id
      JOIN ads ON user_contacts.phone_number_id = ads.phone_number_id
      WHERE ads.deleted = false
    SQL
  end
end

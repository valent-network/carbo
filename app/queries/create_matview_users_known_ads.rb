# frozen_string_literal: true
class CreateMatviewUsersKnownAds
  def call
    <<~SQL
      CREATE MATERIALIZED VIEW users_known_ads AS
      SELECT user_contacts.user_id, ads.id
      FROM active_known_ads AS ads
      JOIN user_contacts ON user_contacts.phone_number_id = ads.phone_number_id
      GROUP BY user_contacts.user_id, ads.id
    SQL
  end
end

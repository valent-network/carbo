class AddClusterIndexes < ActiveRecord::Migration[7.0]
  def up
    execute('CLUSTER user_contacts USING index_user_contacts_on_user_id_and_phone_number_id')
    execute('CLUSTER users USING index_users_on_phone_number_id_and_id')
    execute('CLUSTER ad_descriptions USING index_ad_descriptions_on_ad_id')
    execute('CLUSTER ad_favorites USING index_ad_favorites_on_ad_id_and_user_id')
    execute('CLUSTER ad_image_links_sets USING index_ad_image_links_sets_on_ad_id')
    execute('CLUSTER ad_prices USING index_ad_prices_on_ad_id')
    execute('CLUSTER ad_visits USING index_ad_visits_on_ad_id_and_user_id')
    execute('CLUSTER ad_extras USING index_ad_extras_on_ad_id')
    execute('CLUSTER ad_queries USING index_ad_queries_on_ad_id')
    execute('CLUSTER events USING index_events_on_user_id')
    execute('CLUSTER user_connections USING index_user_connections_for_feed')
    execute('CLUSTER ads USING index_ads_on_phone_number_id_and_id')
  end

  def down
    execute('ALTER TABLE user_contacts SET WITHOUT CLUSTER')
    execute('ALTER TABLE users SET WITHOUT CLUSTER')
    execute('ALTER TABLE ad_descriptions SET WITHOUT CLUSTER')
    execute('ALTER TABLE ad_favorites SET WITHOUT CLUSTER')
    execute('ALTER TABLE ad_image_links_sets SET WITHOUT CLUSTER')
    execute('ALTER TABLE ad_prices SET WITHOUT CLUSTER')
    execute('ALTER TABLE ad_visits SET WITHOUT CLUSTER')
    execute('ALTER TABLE ad_extras SET WITHOUT CLUSTER')
    execute('ALTER TABLE ad_queries SET WITHOUT CLUSTER')
    execute('ALTER TABLE events SET WITHOUT CLUSTER')
    execute('ALTER TABLE user_connections SET WITHOUT CLUSTER')
    execute('ALTER TABLE ads SET WITHOUT CLUSTER')
  end
end

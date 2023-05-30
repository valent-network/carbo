# frozen_string_literal: true

class UpdateUserStatTopRegions
  def call
    <<~SQL
      UPDATE users
      SET stats['top_regions'] = to_jsonb(t.top_regions)
      FROM
      (
        SELECT tt.user_id AS id,
               ARRAY_AGG(DISTINCT region_name) AS top_regions
        FROM (
            SELECT t.user_id,
                   regions.name AS region_name,
                   (ROW_NUMBER() OVER(PARTITION BY t.user_id ORDER BY SUM(t.ads_count) DESC)) AS rank
            FROM (
                SELECT user_connections.user_id,
                       ads.city_id,
                       COUNT(DISTINCT ads.id) AS ads_count
                FROM users_known_users AS user_connections
                JOIN users_known_ads ON users_known_ads.user_id = user_connections.connection_id
                JOIN active_known_ads AS ads ON ads.id = users_known_ads.id
                GROUP BY user_connections.user_id, ads.city_id
                ORDER BY COUNT(DISTINCT ads.id) DESC
            ) AS t
            JOIN cities ON cities.id = t.city_id
            JOIN regions ON regions.id = cities.region_id
            GROUP BY t.user_id, regions.name
        ) AS tt
        WHERE tt.rank <= 3
        GROUP BY tt.user_id
      ) t
      WHERE users.id = t.id
    SQL
  end
end

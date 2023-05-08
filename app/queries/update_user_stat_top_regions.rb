# frozen_string_literal: true

class UpdateUserStatTopRegions
  def call
    <<~SQL
      UPDATE users
      SET stats['top_regions'] = to_jsonb(t.top_regions)
      FROM
      (
        SELECT user_id AS id,
               ARRAY_AGG(regions.name) AS top_regions
        FROM
        (
            SELECT user_connections.user_id,
                   ads.city_id,
                   (ROW_NUMBER() OVER(PARTITION BY user_connections.user_id ORDER BY COUNT(DISTINCT ads.id) DESC)) AS rank
            FROM users_known_users AS user_connections
            JOIN users_known_ads ON users_known_ads.user_id = user_connections.connection_id
            JOIN active_known_ads AS ads ON ads.id = users_known_ads.id
            GROUP BY user_connections.user_id, ads.city_id
            ORDER BY COUNT(DISTINCT ads.id) DESC
        ) AS t
        JOIN cities ON cities.id = t.city_id
        JOIN regions ON regions.id = cities.region_id
        WHERE t.rank <= 3
        GROUP BY t.user_id
      ) t
      WHERE users.id = t.id
    SQL
  end
end

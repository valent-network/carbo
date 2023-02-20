# frozen_string_literal: true
class UpdateUserStatTopRegions
  def call
    <<~SQL
      UPDATE users
      SET stats['top_regions'] = t.top_regions::jsonb
      FROM (
          SELECT users.id,
                 JSON_AGG(regions.name ORDER BY ads_count DESC) AS top_regions
          FROM users
          CROSS JOIN LATERAL (
              SELECT ads.city_id, COUNT(DISTINCT ads.id) AS ads_count
              FROM (SELECT id, phone_number_id, city_id FROM ads WHERE deleted = FALSE) AS ads
              WHERE ads.id IN (
                  SELECT ad_id
                  FROM user_known_ads
                  WHERE user_id = users.id
                  )
              GROUP BY ads.city_id
              ORDER BY ads_count DESC
              LIMIT 3
          ) t
          JOIN cities on t.city_id = cities.id
          JOIN regions on regions.id = cities.region_id
          GROUP BY users.id
      ) t
      WHERE t.id = users.id
    SQL
  end
end

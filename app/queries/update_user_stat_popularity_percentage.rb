# frozen_string_literal: true
class UpdateUserStatPopularityPercentage
  def call
    <<~SQL
      UPDATE users
      SET stats['popularity_percentage'] = to_jsonb(t.popularity_percentage)
      FROM
      (
        SELECT id,
               ROUND((ROW_NUMBER() OVER (ORDER BY t.popularity DESC)::DECIMAL / (SELECT COUNT(*) FROM users)::DECIMAL) * 100) AS popularity_percentage
        FROM (
          SELECT users.id,
                 ROUND(
                  (COALESCE(SUM((s.stats->>'chat_rooms_count'::text)::integer), 0) * 10) +
                  (COALESCE(SUM((s.stats->>'messages_count'::text)::integer), 0) * 0.1) +
                  (COALESCE(SUM((s.stats->>'visits_count'::text)::integer), 0) * 0.5) +
                  (COALESCE(SUM((s.stats->>'favorites_count'::text)::integer), 0) * 5) +
                  ((SELECT COUNT(DISTINCT user_id) FROM user_contacts WHERE phone_number_id = users.phone_number_id) * 200) +
                  ((SELECT COUNT(DISTINCT id) FROM users u WHERE referrer_id = users.id) * 500)
                 ) AS popularity
          FROM users
          LEFT JOIN LATERAL (
                    SELECT ads.stats
                    FROM ads
                    WHERE ads.phone_number_id = users.phone_number_id
                  ) AS s ON true
          GROUP BY users.id
        ) t
        GROUP BY t.id, t.popularity
        ORDER BY popularity_percentage
      ) t
      WHERE users.id = t.id
    SQL
  end
end

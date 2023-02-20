# frozen_string_literal: true
# TODO:
class UpdateUserStatActivityPercentage
  def call
    <<~SQL
      UPDATE users
      SET stats['activity_percentage'] = to_jsonb(t.activity_percentage)
      FROM
      (
        SELECT id,
               ROUND((ROW_NUMBER() OVER (ORDER BY t.activity DESC)::DECIMAL / (SELECT COUNT(*) FROM users)::DECIMAL) * 100) AS activity_percentage
        FROM (
          SELECT users.id,
                 ROUND(
                   ((SELECT COUNT(*) FROM ad_favorites WHERE ad_favorites.user_id = users.id) * 15 )+
                   ((SELECT COUNT(*) FROM messages WHERE messages.user_id = users.id) * 0.05 )+
                   ((SELECT COUNT(*) FROM chat_rooms WHERE chat_rooms.user_id = users.id) * 10 )+
                   ((SELECT COUNT(*) FROM chat_room_users WHERE chat_room_users.user_id = users.id) * 5 )+
                   ((SELECT COUNT(*) FROM events WHERE events.user_id = users.id AND events.name = 'visited_ad') * 2 )+
                   ((SELECT COUNT(*) FROM events WHERE events.user_id = users.id AND events.name = 'get_feed') * 0.5 )+
                   ((select count(DISTINCT ads.id) from ads where ads.phone_number_id = users.phone_number_id) * 75)
                  ) AS activity
          FROM users
          ORDER BY activity DESC
          ) t
          GROUP BY t.id, t.activity
          ORDER BY activity_percentage
      ) t
      WHERE users.id = t.id
    SQL
  end
end

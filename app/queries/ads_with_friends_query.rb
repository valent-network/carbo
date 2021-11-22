# frozen_string_literal: true
class AdsWithFriendsQuery
  def call(user, ads_phone_number_ids)
    phones = ads_phone_number_ids.sort.join(', ')

    <<~SQL
      WITH my_contacts AS (
        SELECT user_contacts.id, users.id AS user_id, user_contacts.name
        FROM user_contacts
        JOIN users ON users.phone_number_id = user_contacts.phone_number_id
        WHERE user_id = #{user.id}
      )
      SELECT
        ads.id,
        my_contacts.id AS friend_id,
        my_contacts.name AS friend_name,
        (COALESCE(t.hops_count, 6) + 1) AS hops_count
      FROM
      (
        SELECT
          user_contacts.phone_number_id,
          user_connections.friend_id,
          user_connections.hops_count,
          (ROW_NUMBER() OVER(PARTITION BY user_contacts.phone_number_id, user_connections.friend_id ORDER BY user_contacts.phone_number_id, user_connections.hops_count, user_connections.friend_id)) AS rank
        FROM user_connections
        JOIN user_contacts ON user_connections.connection_id = user_contacts.user_id
        WHERE user_connections.user_id = #{user.id} AND
              user_contacts.phone_number_id IN (#{phones})
      ) AS t
      JOIN my_contacts ON t.friend_id = my_contacts.user_id
      JOIN ads ON ads.phone_number_id = t.phone_number_id
      WHERE t.rank = 1 AND ads.deleted = FALSE

      UNION

      SELECT DISTINCT ON (ads.id, my_contacts.id)
             ads.id,
             my_contacts.id AS friend_id,
             my_contacts.name AS friend_name,
             1 AS hops_count
      FROM ads
      JOIN user_contacts AS my_contacts ON  my_contacts.phone_number_id = ads.phone_number_id
      WHERE ads.phone_number_id IN (#{phones})
            AND ads.deleted = false
            AND my_contacts.user_id = #{user.id}
    SQL
  end
end

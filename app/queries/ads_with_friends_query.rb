# frozen_string_literal: true
class AdsWithFriendsQuery
  def call(user, ads_phone_number_ids)
    phones = ads_phone_number_ids.sort.join(', ')

    <<~SQL
      SELECT DISTINCT ON (ads.id, my_contacts.id)
             ads.id,
             my_contacts.id AS friend_id,
             my_contacts.name AS friend_name,
             (COALESCE(user_connections.hops_count, 6) + 1) AS hops_count
      FROM ads
      JOIN user_contacts ON ads.phone_number_id = user_contacts.phone_number_id
      JOIN user_connections ON user_connections.connection_id = user_contacts.user_id
      JOIN users AS friends ON user_connections.friend_id = friends.id
      JOIN user_contacts AS my_contacts ON my_contacts.phone_number_id = friends.phone_number_id
      WHERE ads.phone_number_id IN (#{phones})
            AND deleted = false
            AND user_connections.user_id = #{user.id}
            AND my_contacts.user_id = #{user.id}
            AND user_contacts.phone_number_id IN (#{phones})
      UNION

      SELECT DISTINCT ON (ads.id, my_contacts.id)
             ads.id,
             my_contacts.id AS friend_id,
             my_contacts.name AS friend_name,
             1 AS hops_count
      FROM ads
      JOIN user_contacts AS my_contacts ON  my_contacts.phone_number_id = ads.phone_number_id
      WHERE ads.phone_number_id IN (#{phones})
            AND deleted = false
            AND my_contacts.user_id = #{user.id}
    SQL
  end
end

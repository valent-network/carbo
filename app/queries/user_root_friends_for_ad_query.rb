# frozen_string_literal: true
class UserRootFriendsForAdQuery
  def call(user_id, phone_number_ids, max_hands_count: UserFriendlyAdsQuery::MAX_HANDS_COUNT)
    return if phone_number_ids.blank?

    phone_numbers_string = Array.wrap(phone_number_ids).join(',')

    <<~SQL
      WITH RECURSIVE p AS (
        WITH my_contacts AS (SELECT phone_number_id FROM user_contacts WHERE user_contacts.user_id = #{user_id})
        SELECT id, name, phone_number_id, 1 AS idx FROM user_contacts WHERE user_contacts.user_id = #{user_id}

        UNION

        SELECT p.id, p.name, friends.phone_number_id, (p.idx + 1)
        FROM user_contacts AS friends
        JOIN users ON friends.user_id = users.id
        JOIN p ON users.phone_number_id = p.phone_number_id AND users.id != #{user_id}
        LEFT JOIN my_contacts ON my_contacts.phone_number_id = p.phone_number_id
        WHERE p.idx < #{max_hands_count} AND (p.idx = 1 OR my_contacts.phone_number_id IS NULL)
      )

      SELECT id, name, phone_number_id, idx FROM p WHERE p.phone_number_id IN (#{phone_numbers_string}) ORDER BY idx ASC
    SQL
  end
end

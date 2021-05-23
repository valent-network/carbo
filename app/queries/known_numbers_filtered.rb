# frozen_string_literal: true
class KnownNumbersFiltered
  def call(user_id, filtered_friends_phone_number_ids: [])
    <<~SQL
      WITH RECURSIVE p AS (
        SELECT id::bigint AS phone_number_id FROM phone_numbers WHERE id IN (#{filtered_friends_phone_number_ids.join(',')})

        UNION

        SELECT friends.phone_number_id
        FROM user_contacts AS friends
        JOIN users ON friends.user_id = users.id AND users.phone_number_id IN (#{filtered_friends_phone_number_ids.join(',')})
        JOIN p ON users.phone_number_id = p.phone_number_id AND users.id != #{user_id}
      )

      SELECT DISTINCT phone_number_id FROM p
    SQL
  end
end

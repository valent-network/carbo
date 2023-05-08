# frozen_string_literal: true

class KnownNumbersFiltered
  def call(user_id, filtered_friends_phone_number_ids: [])
    <<~SQL
      SELECT phone_number_id FROM UNNEST(ARRAY[#{filtered_friends_phone_number_ids.join(",")}]) AS phone_number_id

      UNION

      SELECT user_contacts.phone_number_id
      FROM user_contacts
      JOIN users ON users.phone_number_id IN (#{filtered_friends_phone_number_ids.join(",")})
      JOIN user_connections ON user_connections.user_id = #{user_id} AND user_connections.connection_id = users.id
      WHERE user_contacts.user_id = user_connections.connection_id
    SQL
  end
end

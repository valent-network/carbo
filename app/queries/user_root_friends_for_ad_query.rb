# frozen_string_literal: true
class UserRootFriendsForAdQuery
  def call(user_id, phone_number_ids)
    return if phone_number_ids.blank?

    phone_numbers_string = Array.wrap(phone_number_ids).join(',')

    <<~SQL
      WITH user_connections AS (
        WITH known_users AS (
          WITH RECURSIVE p AS (
            WITH my_contacts AS (SELECT phone_number_id FROM effective_user_contacts WHERE user_id = #{user_id})

            SELECT user_contacts.id, user_contacts.name, users.id AS user_id
            FROM users
            JOIN effective_user_contacts AS user_contacts ON user_contacts.phone_number_id = users.phone_number_id AND user_contacts.user_id = #{user_id}

            UNION

            SELECT p.id, p.name, new_users.id AS user_id
            FROM p
            JOIN effective_user_contacts AS user_contacts ON user_contacts.user_id = p.user_id
            JOIN users AS new_users ON user_contacts.phone_number_id = new_users.phone_number_id AND new_users.id != #{user_id}
            LEFT JOIN my_contacts ON my_contacts.phone_number_id = new_users.phone_number_id
            WHERE my_contacts.phone_number_id IS NULL
          )

          SELECT id, name, user_id FROM p
        )

        SELECT known_users.id, known_users.name, users.phone_number_id
        FROM known_users
        JOIN users ON users.id = known_users.user_id
      )

      SELECT user_contacts.id, user_contacts.name, user_contacts.phone_number_id, TRUE AS is_first_hand
      FROM users
      JOIN effective_user_contacts AS user_contacts ON user_contacts.phone_number_id IN (#{phone_numbers_string}) AND user_contacts.user_id = #{user_id}

      UNION

      SELECT user_connections.id, user_connections.name, user_contacts.phone_number_id, FALSE AS is_first_hand
      FROM user_connections
      JOIN users ON users.phone_number_id = user_connections.phone_number_id
      JOIN user_contacts ON users.id = user_contacts.user_id AND user_contacts.phone_number_id IN (#{phone_numbers_string})
    SQL
  end
end

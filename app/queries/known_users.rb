# frozen_string_literal: true
class KnownUsers
  def call(user_id)
    <<~SQL
      WITH RECURSIVE p AS (

        SELECT users.id
        FROM users
        JOIN user_contacts ON user_contacts.phone_number_id = users.phone_number_id AND user_contacts.user_id = #{user_id}

        UNION

        SELECT new_users.id
        FROM p
        JOIN effective_user_contacts ON effective_user_contacts.user_id = p.id
        JOIN users AS new_users ON effective_user_contacts.phone_number_id = new_users.phone_number_id
      )

      SELECT DISTINCT id FROM p
    SQL
  end
end

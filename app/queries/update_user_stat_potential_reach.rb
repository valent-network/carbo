# frozen_string_literal: true

class UpdateUserStatPotentialReach
  def call
    <<~SQL
      UPDATE users
      SET stats['potential_reach'] = to_jsonb(t.potential_reach)
      FROM
      (
        SELECT users.id,
               COUNT(DISTINCT friends.id) AS potential_reach
        FROM users
        LEFT JOIN user_connections ON user_connections.user_id = users.id
        LEFT JOIN users AS friends ON friends.id = user_connections.connection_id
        GROUP BY users.id
      ) AS t
      WHERE t.id = users.id
    SQL
  end
end

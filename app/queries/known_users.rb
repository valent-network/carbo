# frozen_string_literal: true
class KnownUsers
  def call(user_id)
    <<~SQL
      SELECT connection_id AS id FROM user_connections WHERE user_id = #{user_id}
    SQL
  end
end

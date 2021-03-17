# frozen_string_literal: true
class EffectiveKnownNumbers
  def call(user_id)
    known_users_sql = KnownUsers.new.call(user_id)
    <<~SQL
      WITH known_users AS (#{known_users_sql})
      SELECT DISTINCT phone_number_id FROM user_contacts WHERE user_id = #{user_id}

      UNION

      SELECT DISTINCT phone_number_id
      FROM effective_user_contacts
      WHERE user_id IN (SELECT id FROM known_users)
    SQL
  end
end

# frozen_string_literal: true
class EffectiveKnownNumbers
  def call(user_id)
    <<~SQL
      SELECT phone_number_id
      FROM user_contacts
      WHERE user_id IN (#{KnownUsers.new.call(user_id)})
    SQL
  end
end

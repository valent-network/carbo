# frozen_string_literal: true

class UpdateUserStatAdoptionPercentage
  def call
    <<~SQL
      UPDATE users
      SET stats['adoption_percentage'] = to_jsonb(t.adoption_percentage)
      FROM
      (
        SELECT users.id,
           ROUND((ROW_NUMBER() OVER (ORDER BY users.created_at ASC)::DECIMAL / (SELECT COUNT(*) FROM users)::DECIMAL) * 100) AS adoption_percentage
        FROM users
        GROUP BY users.id
      ) AS t
      WHERE t.id = users.id
    SQL
  end
end

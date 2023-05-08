# frozen_string_literal: true

class CreateKnownOptionsMatview < ActiveRecord::Migration[7.0]
  def up
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW known_options AS
      WITH options AS (SELECT JSONB_OBJECT_KEYS(details) AS k FROM ad_extras GROUP BY k)
      SELECT DISTINCT k, ad_extras.details->>options.k AS v
      FROM options
      JOIN ad_extras ON details->>options.k != '' AND details IS NOT NULL
      ORDER BY k
    SQL
  end

  def down
    execute("DROP MATERIALIZED VIEW known_options")
  end
end

# frozen_string_literal: true
class CreateAdsGroupedByMakerModelYearUsingMaterializedView < ActiveRecord::Migration[6.0]
  def up
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW ads_grouped_by_maker_model_year AS (
        SELECT details->>'maker' AS maker,
               details->>'model' AS model,
               details->>'year' AS year,
               MIN(price) AS min_price,
               ROUND(AVG(price) / 100) * 100 AS avg_price,
               MAX(price) AS max_price
        FROM ads
        WHERE deleted = 'F' AND updated_at >= NOW() - INTERVAL '2 months'
        GROUP BY maker, model, year
        ORDER BY maker, model, year
      )
    SQL

    add_index(:ads_grouped_by_maker_model_year, %w[min_price max_price], name: 'search_budget_index')
  end

  def down
    execute('DROP MATERIALIZED VIEW ads_grouped_by_maker_model_year')
  end
end

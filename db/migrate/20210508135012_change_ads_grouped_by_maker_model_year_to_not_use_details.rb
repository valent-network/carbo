class ChangeAdsGroupedByMakerModelYearToNotUseDetails < ActiveRecord::Migration[6.1]
  def up
    execute('DROP MATERIALIZED VIEW ads_grouped_by_maker_model_year')
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW ads_grouped_by_maker_model_year AS (
        SELECT maker,
               model,
               year,
               MIN(price) AS min_price,
               ROUND(AVG(price) / 100) * 100 AS avg_price,
               MAX(price) AS max_price
        FROM (
          SELECT ads.id,
                 price,
                 MAX(ad_option_values.value) FILTER (WHERE ad_options.ad_option_type_id = 6) AS maker,
                 MAX(ad_option_values.value) FILTER (WHERE ad_options.ad_option_type_id = 7) AS model,
                 MAX(ad_option_values.value) FILTER (WHERE ad_options.ad_option_type_id = 4) AS year
          FROM ads
          JOIN ad_options ON ads.id = ad_options.ad_id AND ad_options.ad_option_type_id IN (4,6,7)
          JOIN ad_option_values ON ad_option_values.id = ad_options.ad_option_value_id
          WHERE deleted = 'F'
          GROUP BY ads.id
        ) AS ads
        GROUP BY maker, model, year
        HAVING COUNT(ads) >= 5
        ORDER BY maker, model, year
      )
    SQL

    add_index(:ads_grouped_by_maker_model_year, %w[min_price max_price], name: 'search_budget_index')
  end

  def down
    execute('DROP MATERIALIZED VIEW ads_grouped_by_maker_model_year')
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW ads_grouped_by_maker_model_year AS (
        SELECT details->>'maker' AS maker,
               details->>'model' AS model,
               details->>'year' AS year,
               MIN(price) AS min_price,
               ROUND(AVG(price) / 100) * 100 AS avg_price,
               MAX(price) AS max_price
        FROM ads
        WHERE deleted = 'F'
          AND updated_at >= NOW() - INTERVAL '2 months'
          AND price < 200000
        GROUP BY maker, model, year
        HAVING COUNT(ads) >= 5
        ORDER BY maker, model, year
      )
    SQL

    add_index(:ads_grouped_by_maker_model_year, %w[min_price max_price], name: 'search_budget_index')
  end
end

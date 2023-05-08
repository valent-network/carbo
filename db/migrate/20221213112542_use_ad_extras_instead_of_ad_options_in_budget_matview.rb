# frozen_string_literal: true

class UseAdExtrasInsteadOfAdOptionsInBudgetMatview < ActiveRecord::Migration[7.0]
  def up
    execute("DROP MATERIALIZED VIEW ads_grouped_by_maker_model_year")
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW ads_grouped_by_maker_model_year AS (
        SELECT
           details->>'maker' AS maker,
           details->>'model' AS model,
           details->>'year' AS year,
           min(ads.price) AS min_price,
           (round((avg(ads.price) / (100)::numeric)) * (100)::numeric) AS avg_price,
           max(ads.price) AS max_price
        FROM ads
        JOIN ad_extras ON ads.id = ad_extras.ad_id
        WHERE ads.deleted = FALSE
        GROUP BY ad_extras.details->>'maker', ad_extras.details->>'model', ad_extras.details->>'year'
        HAVING (count(ads.*) >=5)
        ORDER BY ad_extras.details->>'maker', ad_extras.details->>'model', ad_extras.details->>'year'
      )
    SQL
    add_index(:ads_grouped_by_maker_model_year, %w[min_price max_price], name: "search_budget_index")
  end

  def down
    execute("DROP MATERIALIZED VIEW ads_grouped_by_maker_model_year")
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW ads_grouped_by_maker_model_year AS (
        SELECT maker,
               model,
               year,
               MIN(price) AS min_price,
               ROUND(AVG(price) / 100) * 100 AS avg_price,
               MAX(price) AS max_price
        FROM (
          SELECT ads.price,
                 options->>'maker' AS maker,
                 options->>'model' AS model,
                 options->>'year' AS year
          FROM (
            SELECT ads.id,
                   ads.price,
                   JSON_OBJECT(ARRAY_AGG(array[ad_option_types.name, ad_option_values.value])) AS options
            FROM (SELECT id, phone_number_id, price FROM ads WHERE deleted = FALSE) AS ads
            LEFT JOIN ad_options on ad_options.ad_id = ads.id AND ad_options.ad_option_type_id IN (SELECT id FROM ad_option_types WHERE name IN ('maker', 'model', 'year'))
            JOIN ad_option_types on ad_options.ad_option_type_id = ad_option_types.id
            JOIN ad_option_values on ad_options.ad_option_value_id = ad_option_values.id
            GROUP BY ads.id, ads.price
          ) AS ads
        ) AS ads
        GROUP BY maker, model, year
        HAVING COUNT(ads) >= 5
        ORDER BY maker, model, year
      )
    SQL
    add_index(:ads_grouped_by_maker_model_year, %w[min_price max_price], name: "search_budget_index")
  end
end

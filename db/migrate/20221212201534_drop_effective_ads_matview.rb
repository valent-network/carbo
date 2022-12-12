# frozen_string_literal: true
class DropEffectiveAdsMatview < ActiveRecord::Migration[7.0]
  def up
    execute('DROP MATERIALIZED VIEW effective_ads')
  end

  def down
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW effective_ads AS (
        SELECT ads.id,
              ads.phone_number_id,
              ads.price,
              (options->>'year')::smallint AS year,
              (
                (options->>'maker') || ' ' || (options->>'model') || ' ' || (options->>'year')
              ) AS search_query,
              options->>'fuel' AS fuel,
              options->>'wheels' AS wheels,
              options->>'gear' AS gear,
              options->>'carcass' AS carcass
        FROM (
          SELECT ads.id,
                 ads.phone_number_id,
                 ads.price,
                 JSON_OBJECT(ARRAY_AGG(array[ad_option_types.name, ad_option_values.value])) AS options
          FROM known_ads AS ads
          JOIN ad_options on ad_options.ad_id = ads.id AND ad_options.ad_option_type_id IN (1,2,4,6,7,9,11)
          JOIN ad_option_types on ad_options.ad_option_type_id = ad_option_types.id
          JOIN ad_option_values on ad_options.ad_option_value_id = ad_option_values.id
          GROUP BY ads.id, ads.phone_number_id, ads.price
        ) AS ads
      )
    SQL

    add_index(:effective_ads, :id, unique: true, order: { id: :desc })
    add_index(:effective_ads, %w[phone_number_id id], order: { id: :desc })
    add_index(:effective_ads, :search_query, using: :gin, opclass: { title: :gin_trgm_ops })
  end
end

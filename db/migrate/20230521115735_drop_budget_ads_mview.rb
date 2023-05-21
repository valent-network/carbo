class DropBudgetAdsMview < ActiveRecord::Migration[7.0]
  def up
    execute("DROP MATERIALIZED VIEW ads_grouped_by_maker_model_year")
  end

  def down
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW public.ads_grouped_by_maker_model_year AS
       SELECT (ad_extras.details ->> 'maker'::text) AS maker,
          (ad_extras.details ->> 'model'::text) AS model,
          (ad_extras.details ->> 'year'::text) AS year,
          min(ads.price) AS min_price,
          (round((avg(ads.price) / (100)::numeric)) * (100)::numeric) AS avg_price,
          max(ads.price) AS max_price
         FROM (public.ads
           JOIN public.ad_extras ON ((ads.id = ad_extras.ad_id)))
        WHERE (ads.deleted = false)
        GROUP BY (ad_extras.details ->> 'maker'::text), (ad_extras.details ->> 'model'::text), (ad_extras.details ->> 'year'::text)
       HAVING (count(ads.*) >= 5)
        ORDER BY (ad_extras.details ->> 'maker'::text), (ad_extras.details ->> 'model'::text), (ad_extras.details ->> 'year'::text)
    SQL
    execute(<<~SQL)
      CREATE UNIQUE INDEX index_ads_grouped_by_maker_model_year_on_uniq ON public.ads_grouped_by_maker_model_year USING btree (maker, model, year);
    SQL
  end
end

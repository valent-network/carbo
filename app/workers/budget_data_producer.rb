class BudgetDataProducer
  QUERY = <<~SQL
    SELECT maker,
           model,
           year,
           MIN(min_price)::text AS min_price,
           MAX(max_price)::text AS max_price,
           (round((avg(avg_price) / (100)::numeric)) * (100)::numeric)::integer::text AS avg_price,
           json_object_agg(region_name, ads_count) AS regions
    FROM (

      SELECT
        t1.maker,
        t1.model,
        t1.year,
        t1.min_price,
        t1.avg_price,
        t1.max_price,
        t1.region_name,
        t1.ads_count
      FROM (
        SELECT
          (ad_extras.details ->> 'maker'::text) AS maker,
          (ad_extras.details ->> 'model'::text) AS model,
          (ad_extras.details ->> 'year'::text) AS year,
          min(ads.price) AS min_price,
          (round((avg(ads.price) / (100)::numeric)) * (100)::numeric) AS avg_price,
          max(ads.price) AS max_price,
          COUNT(DISTINCT ads.id) AS ads_count,
          regions.translations->>'uk' AS region_name
        FROM
          public.ads
          JOIN public.ad_extras ON ads.id = ad_extras.ad_id
          JOIN cities ON ads.city_id = cities.id
          JOIN regions ON cities.region_id = regions.id
        WHERE
          ads.deleted = false
        GROUP BY
          ad_extras.details ->> 'maker'::text,
          ad_extras.details ->> 'model'::text,
          ad_extras.details ->> 'year'::text,
          regions.translations
        HAVING
          count(ads.*) >= 5
      ) t1
      GROUP BY
        t1.maker,
        t1.model,
        t1.year,
        t1.min_price,
        t1.avg_price,
        t1.max_price,
        t1.ads_count,
        t1.region_name
    ) AS t2
    GROUP BY
      t2.maker,
      t2.model,
      t2.year
    ORDER BY
      t2.maker,
      t2.model,
      t2.year
  SQL

  def perform
    data = ActiveRecord::Base.connection.execute(QUERY).to_json
    etag = Digest::MD5.hexdigest(data.to_s)
    REDIS.set("budget_data", data)
    REDIS.set("budget_data.etag", etag)
  end
end

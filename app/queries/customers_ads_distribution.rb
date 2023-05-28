class CustomersAdsDistribution
  def call(active_ads_only: true, potential_customers_only: false)
    <<~SQL
      SELECT '0' AS ads_count, COUNT(*) AS users_count
      FROM (
        SELECT phone_numbers.id, COUNT(DISTINCT ads.id) AS count_ads
        FROM phone_numbers
        #{potential_customers_only ? "LEFT " : ""}JOIN users ON users.phone_number_id = phone_numbers.id
        LEFT JOIN ads ON ads.phone_number_id = phone_numbers.id#{active_ads_only ? " AND ads.deleted = false" : ""}#{potential_customers_only ? "\nWHERE users.id IS NULL" : ""}
        GROUP BY phone_numbers.id
      ) AS t
      WHERE count_ads = 0

      UNION 

      SELECT '1-10' AS ads_count, COUNT(*) AS users_count
      FROM (
        SELECT phone_numbers.id, COUNT(DISTINCT ads.id) AS count_ads
        FROM phone_numbers
        #{potential_customers_only ? "LEFT " : ""}JOIN users ON users.phone_number_id = phone_numbers.id
        JOIN ads ON ads.phone_number_id = phone_numbers.id#{active_ads_only ? " AND ads.deleted = false" : ""}#{potential_customers_only ? "\nWHERE users.id IS NULL" : ""}
        GROUP BY phone_numbers.id
      ) AS t
      WHERE count_ads BETWEEN 1 AND 10

      UNION 

      SELECT '11-100' AS ads_count, COUNT(*) AS users_count
      FROM (
        SELECT phone_numbers.id, COUNT(DISTINCT ads.id) AS count_ads
        FROM phone_numbers
        #{potential_customers_only ? "LEFT " : ""}JOIN users ON users.phone_number_id = phone_numbers.id
        JOIN ads ON ads.phone_number_id = phone_numbers.id#{active_ads_only ? " AND ads.deleted = false" : ""}#{potential_customers_only ? "\nWHERE users.id IS NULL" : ""}
        GROUP BY phone_numbers.id
      ) AS t
      WHERE count_ads BETWEEN 11 AND 100
      UNION 

      SELECT '101-500' AS ads_count, COUNT(*) AS users_count
      FROM (
        SELECT phone_numbers.id, COUNT(DISTINCT ads.id) AS count_ads
        FROM phone_numbers
        #{potential_customers_only ? "LEFT " : ""}JOIN users ON users.phone_number_id = phone_numbers.id
        JOIN ads ON ads.phone_number_id = phone_numbers.id#{active_ads_only ? " AND ads.deleted = false" : ""}#{potential_customers_only ? "\nWHERE users.id IS NULL" : ""}
        GROUP BY phone_numbers.id
      ) AS t
      WHERE count_ads BETWEEN 101 AND 500
      UNION 

      SELECT '500+' AS ads_count, COUNT(*) AS users_count
      FROM (
        SELECT phone_numbers.id, COUNT(DISTINCT ads.id) AS count_ads
        FROM phone_numbers
        #{potential_customers_only ? "LEFT " : ""}JOIN users ON users.phone_number_id = phone_numbers.id
        JOIN ads ON ads.phone_number_id = phone_numbers.id#{active_ads_only ? " AND ads.deleted = false" : ""}#{potential_customers_only ? "\nWHERE users.id IS NULL" : ""}
        GROUP BY phone_numbers.id
      ) AS t
      WHERE count_ads > 500
    SQL
  end
end

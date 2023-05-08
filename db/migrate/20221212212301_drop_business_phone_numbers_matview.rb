# frozen_string_literal: true

class DropBusinessPhoneNumbersMatview < ActiveRecord::Migration[7.0]
  def up
    execute("DROP MATERIALIZED VIEW business_phone_numbers")
  end

  def down
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW business_phone_numbers AS (
        SELECT ads.phone_number_id, COUNT(ads.phone_number_id) AS ads_count
        FROM ads
        JOIN phone_numbers ON ads.phone_number_id = phone_numbers.id
        WHERE ads.created_at > NOW() - INTERVAL '1 year'
        GROUP BY ads.phone_number_id
        HAVING COUNT(ads.phone_number_id) > 5
      )
    SQL

    add_index(:business_phone_numbers, :phone_number_id, unique: true)
  end
end

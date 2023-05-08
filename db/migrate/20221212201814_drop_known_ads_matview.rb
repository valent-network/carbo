# frozen_string_literal: true

class DropKnownAdsMatview < ActiveRecord::Migration[7.0]
  def up
    execute("DROP MATERIALIZED VIEW known_ads")
  end

  def down
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW known_ads AS (
        SELECT DISTINCT ads.id, ads.phone_number_id, ads.price
        FROM ads
        WHERE ads.deleted = 'F' AND
              ads.phone_number_id IN (SELECT phone_number_id FROM user_contacts)
      )
    SQL
    add_index(:known_ads, [:id, :phone_number_id, :price])
    add_index(:known_ads, :id, unique: true)
  end
end

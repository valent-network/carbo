class CreateKnownAdsMatview < ActiveRecord::Migration[6.1]
  def up
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

  def down
    execute('DROP MATERIALIZED VIEW known_ads')
  end
end

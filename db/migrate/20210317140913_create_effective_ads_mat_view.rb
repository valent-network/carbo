# frozen_string_literal: true
class CreateEffectiveAdsMatView < ActiveRecord::Migration[6.1]
  def up
    execute(<<~SQL)
      CREATE MATERIALIZED VIEW effective_ads AS (
        SELECT DISTINCT ads.id, ads.phone_number_id, ads.price, ads.details
        FROM ads
        JOIN user_contacts ON user_contacts.phone_number_id = ads.phone_number_id
        WHERE ads.deleted = 'F' AND ads.updated_at >= NOW() - INTERVAL '2 months'
      )
      WITH DATA
    SQL

    add_index(:effective_ads, :id, unique: true, order: { id: :desc })
    add_index(:effective_ads, %w[phone_number_id id], order: { id: :desc })
    add_index(:effective_ads, :price)
    # add_index(:effective_ads, :details)
  end

  def down
    execute('DROP MATERIALIZED VIEW effective_ads')
  end
end

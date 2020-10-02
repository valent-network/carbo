# frozen_string_literal: true
class AddMoreAdsIndexes < ActiveRecord::Migration[6.0]
  def change
    enable_extension('pg_trgm')
    enable_extension('btree_gist')
    add_index(:ads, "(details->>'model')", using: :gist, opclass: { title: :gist_trgm_ops }, name: 'index_ads_on_details_model')
    add_index(:ads, "(details->>'maker')", using: :gist, opclass: { title: :gist_trgm_ops }, name: 'index_ads_on_details_maker')
    add_index(:ads, "(details->>'year')", name: 'index_ads_on_details_year')
    add_index(:ads, "(details->>'fuel')", name: 'index_ads_on_details_fuel')
    add_index(:ads, "(details->>'gear')", name: 'index_ads_on_details_gear')
    add_index(:ads, "(details->>'wheels')", name: 'index_ads_on_details_wheels')
    add_index(:ads, "(details->>'carcass')", name: 'index_ads_on_details_carcass')
    add_index(:ads, :price)
    add_index(:ads, :created_at)
    add_index(:ads, :updated_at)
    add_index(:ads, [:phone_number_id, :created_at], name: :feed_index)
    remove_index(:ads, name: :index_ads_on_phone_number_id_and_updated_at_and_ads_source_id)
    remove_index(:ads, :ads_source_id)
  end
end

# frozen_string_literal: true
class ManageAdsIndexes < ActiveRecord::Migration[6.1]
  def change
    remove_index(:ads, name: :index_ads_on_details_carcass)
    remove_index(:ads, name: :index_ads_on_details_fuel)
    remove_index(:ads, name: :index_ads_on_details_gear)
    remove_index(:ads, name: :index_ads_on_details_maker)
    remove_index(:ads, name: :index_ads_on_details_model)
    remove_index(:ads, name: :index_ads_on_details_wheels)
    remove_index(:ads, name: :index_ads_on_details_year)
    remove_index(:ads, name: :index_ads_on_phone_number_id_and_created_at)
    remove_index(:ads, name: :index_ads_on_price)
    remove_index(:ads, name: :details_region_year_maker_model_index)

    add_index(:ads, %w[phone_number_id updated_at price], order: { updated_at: :desc }, where: 'deleted = false')
    execute("CREATE INDEX details_region_year_maker_model_index ON public.ads USING btree ((((details -> 'region'::text) ->> 0)), ((details ->> 'year'::text)), ((details ->> 'maker'::text)), ((details ->> 'model'::text))) WHERE deleted = FALSE")
  end

  def down
    remove_index(:ads, %w[phone_number_id updated_at price])
    remove_index(:ads, name: :details_region_year_maker_model_index)

    add_index(:ads, name: :index_ads_on_details_carcass, column: "(details->>'carcass')", using: :gist, opclass: { title: :gist_trgm_ops })
    add_index(:ads, name: :index_ads_on_details_fuel, column: "(details->>'fuel')", using: :gist, opclass: { title: :gist_trgm_ops })
    add_index(:ads, name: :index_ads_on_details_gear, column: "(details->>'gear')", using: :gist, opclass: { title: :gist_trgm_ops })
    add_index(:ads, name: :index_ads_on_details_maker, column: "(details->>'maker')", using: :gist, opclass: { title: :gist_trgm_ops })
    add_index(:ads, name: :index_ads_on_details_model, column: "(details->>'model')", using: :gist, opclass: { title: :gist_trgm_ops })
    add_index(:ads, name: :index_ads_on_details_wheels, column: "(details->>'wheels')", using: :gist, opclass: { title: :gist_trgm_ops })
    add_index(:ads, name: :index_ads_on_details_year, column: "(details->>'year')", using: :gist, opclass: { title: :gist_trgm_ops })
    add_index(:ads, name: :index_ads_on_phone_number_id_and_created_at, column: %w[phone_number_id created_at])
    add_index(:ads, name: :index_ads_on_price, column: :price)

    execute("CREATE INDEX details_region_year_maker_model_index ON ads((details->'region'->>0), (details->>'year'), (details->>'maker'), (details->>'model'))")
  end
end

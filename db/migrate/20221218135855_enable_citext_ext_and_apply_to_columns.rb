# frozen_string_literal: true

class EnableCitextExtAndApplyToColumns < ActiveRecord::Migration[7.0]
  def up
    enable_extension("citext")
    change_column(:ad_option_types, :name, :citext)
    change_column(:ads_sources, :title, :citext)
    change_column(:categories, :name, :citext)
    change_column(:cities, :name, :citext)
    change_column(:regions, :name, :citext)
    change_column(:filterable_values, :name, :citext)
    change_column(:nativized_provider_ads, :address, :citext)
    change_column(:ads, :address, :citext)
  end

  def down
    change_column(:ad_option_types, :name, :string)
    change_column(:ads_sources, :title, :string)
    change_column(:categories, :name, :string)
    change_column(:cities, :name, :string)
    change_column(:regions, :name, :string)
    change_column(:filterable_values, :name, :string)
    change_column(:nativized_provider_ads, :address, :string)
    change_column(:ads, :address, :string)
    disable_extension("citext")
  end
end

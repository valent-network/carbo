# frozen_string_literal: true
class OptimizeDataTypeForMemoryFootprintNonMatview < ActiveRecord::Migration[6.1]
  def up
    change_column(:ad_descriptions, :id, 'integer')
    change_column(:ad_descriptions, :ad_id, 'integer')

    change_column(:ad_image_links_sets, :ad_id, 'integer')
    change_column(:ad_image_links_sets, :id, 'integer')

    change_column(:ad_option_types, :id, 'smallint')

    change_column(:ad_prices, :id, 'integer')
    change_column(:ad_prices, :ad_id, 'integer')

    change_column(:ad_options, :id, 'integer')

    change_column(:phone_numbers, :id, 'integer')

    change_column(:ads, :ads_source_id, 'smallint')
  end

  def down
    change_column(:ad_descriptions, :id, 'bigint')
    change_column(:ad_descriptions, :ad_id, 'bigint')

    change_column(:ad_image_links_sets, :ad_id, 'bigint')
    change_column(:ad_image_links_sets, :id, 'bigint')

    change_column(:ad_option_types, :id, 'bigint')

    change_column(:ad_prices, :id, 'bigint')
    change_column(:ad_prices, :ad_id, 'bigint')

    change_column(:ad_options, :id, 'bigint')

    change_column(:phone_numbers, :id, 'bigint')

    change_column(:ads, :ads_source_id, 'bigint')
  end
end

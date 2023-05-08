# frozen_string_literal: true

class AdjustAdOptionsIndexesForFasterRefreshEffectiveAdsMatview < ActiveRecord::Migration[6.1]
  def change
    add_index(:ad_options, [:ad_id, :ad_option_value_id], where: "ad_option_type_id IN (1, 2, 4, 6, 7, 9, 11)")
  end
end

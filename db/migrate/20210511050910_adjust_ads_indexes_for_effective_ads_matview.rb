# frozen_string_literal: true

class AdjustAdsIndexesForEffectiveAdsMatview < ActiveRecord::Migration[6.1]
  def change
    remove_index(:ads, :phone_number_id)
    remove_index(:ads, %w[phone_number_id updated_at price], order: {updated_at: :desc}, where: "deleted = false")

    execute("CREATE INDEX index_ads_on_phone_number_id_where_deleted_false_include_price ON ads(phone_number_id) INCLUDE(price) WHERE deleted = FALSE")
  end
end

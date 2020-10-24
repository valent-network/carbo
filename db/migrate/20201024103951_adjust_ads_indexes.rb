# frozen_string_literal: true
class AdjustAdsIndexes < ActiveRecord::Migration[6.0]
  def change
    remove_index(:ads, :updated_at)
    remove_index(:ads, :created_at)
    remove_index(:ads, name: :feed_index)
    remove_index(:ads, name: :index_ads_on_phone_number_id)

    add_index(:ads, %i[phone_number_id created_at], order: { created_at: :desc }, where: "(deleted = false)")
  end
end

# frozen_string_literal: true

class CreateUniqueIndexOnAdsGroupedMview < ActiveRecord::Migration[7.0]
  def change
    add_index(:ads_grouped_by_maker_model_year, [:maker, :model, :year], unique: true, name: :index_ads_grouped_by_maker_model_year_on_uniq)
  end
end

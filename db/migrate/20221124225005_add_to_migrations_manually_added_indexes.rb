# frozen_string_literal: true

class AddToMigrationsManuallyAddedIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index(:events, %i[user_id created_at], where: "(name)::text = 'snapshot_user_visibility'::text")
    add_index(:dashboard_stats, :updated_at, unique: true)
    add_index(:ads_grouped_by_maker_model_year, %i[model maker year], unique: true, name: "ads_grouped_by_maker_model_year_model_maker_year_idx")
  end
end

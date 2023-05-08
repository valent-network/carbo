# frozen_string_literal: true

class RemoveColumnAdOptionValueIdFromFilterableValues < ActiveRecord::Migration[7.0]
  def change
    remove_index(:filterable_values, :ad_option_value_id)
    remove_column(:filterable_values, :ad_option_value_id, :bigint)
  end
end

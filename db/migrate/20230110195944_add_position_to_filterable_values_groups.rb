# frozen_string_literal: true

class AddPositionToFilterableValuesGroups < ActiveRecord::Migration[7.0]
  def change
    add_column(:filterable_values_groups, :position, :integer)
  end
end

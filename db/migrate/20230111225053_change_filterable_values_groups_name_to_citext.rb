# frozen_string_literal: true

class ChangeFilterableValuesGroupsNameToCitext < ActiveRecord::Migration[7.0]
  def change
    change_column(:filterable_values_groups, :name, :citext)
  end
end

# frozen_string_literal: true
class CreateFilterableValuesGroups < ActiveRecord::Migration[7.0]
  def change
    create_table(:filterable_values_groups) do |t|
      t.belongs_to(:ad_option_type)
      t.string(:name)
      t.jsonb(:translations, default: {})
      t.timestamps
    end

    add_index(:filterable_values_groups, [:name, :ad_option_type_id], unique: true)
  end
end

# frozen_string_literal: true

class CreateFilterableValues < ActiveRecord::Migration[7.0]
  def change
    create_table(:filterable_values) do |t|
      t.belongs_to(:ad_option_type)
      t.belongs_to(:ad_option_value)
      t.string(:name, null: false)
      t.timestamps
    end

    add_index(:filterable_values, [:ad_option_value_id, :ad_option_type_id], unique: true, name: :index_filterable_values_on_eav)
  end
end

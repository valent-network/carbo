# frozen_string_literal: true

class AddUniqueIndexOnFilterableValues < ActiveRecord::Migration[7.0]
  def change
    add_index(:filterable_values, %i[ad_option_type_id raw_value], unique: true)
  end
end

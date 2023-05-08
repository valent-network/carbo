# frozen_string_literal: true

class AddNotNullConstraints < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:filterable_values, :ad_option_type_id, false)
    change_column_null(:filterable_values, :raw_value, false)
    change_column_null(:ad_option_types, :category_id, false)
    change_column_null(:ads, :category_id, false)
  end
end

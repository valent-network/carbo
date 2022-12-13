class AddRawValueToFilterableValues < ActiveRecord::Migration[7.0]
  def change
    add_column :filterable_values, :raw_value, :string
  end
end

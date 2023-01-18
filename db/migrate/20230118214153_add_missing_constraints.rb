class AddMissingConstraints < ActiveRecord::Migration[7.0]
  def change
    change_column_null :filterable_values_groups, :ad_option_type_id, false
    change_column_null :filterable_values_groups, :name, false
    change_column_null :ad_queries, :title, false
    change_column_null :categories, :currency, false
    change_column_null :cities, :region_id, false
    change_column_null :events, :user_id, false
    change_column_null :events, :name, false
    change_column_null :ad_option_types, :name, false

    add_foreign_key :filterable_values_groups, :ad_option_types
    add_foreign_key :events, :users
  end
end

# frozen_string_literal: true

class AddFilterableToAdOptions < ActiveRecord::Migration[7.0]
  def change
    add_column(:ad_option_types, :filterable, :boolean, default: false, null: false)
  end
end

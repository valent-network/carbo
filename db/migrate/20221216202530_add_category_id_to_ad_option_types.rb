# frozen_string_literal: true
class AddCategoryIdToAdOptionTypes < ActiveRecord::Migration[7.0]
  def change
    add_reference(:ad_option_types, :category, null: true, foreign_key: true)
  end
end

# frozen_string_literal: true

class AddCategoryIdToAds < ActiveRecord::Migration[7.0]
  def change
    add_reference(:ads, :category, null: true, foreign_key: true)
  end
end

# frozen_string_literal: true
class AddTranslationsToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column(:categories, :translations, :jsonb, default: {})
  end
end

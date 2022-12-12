# frozen_string_literal: true
class AddTranslationsToCities < ActiveRecord::Migration[7.0]
  def change
    add_column(:cities, :translations, :jsonb, default: {})
  end
end

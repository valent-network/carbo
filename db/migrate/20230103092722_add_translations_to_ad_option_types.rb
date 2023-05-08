# frozen_string_literal: true

class AddTranslationsToAdOptionTypes < ActiveRecord::Migration[7.0]
  def change
    add_column(:ad_option_types, :translations, :jsonb, default: {})
  end
end

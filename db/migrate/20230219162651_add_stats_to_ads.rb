# frozen_string_literal: true

class AddStatsToAds < ActiveRecord::Migration[7.0]
  def change
    add_column(:ads, :stats, :jsonb, default: {})
  end
end

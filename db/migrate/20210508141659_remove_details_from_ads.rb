# frozen_string_literal: true

class RemoveDetailsFromAds < ActiveRecord::Migration[6.1]
  def change
    remove_column(:ads, :details, :jsonb, null: false)
  end
end

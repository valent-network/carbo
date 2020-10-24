# frozen_string_literal: true
class RemoveStaleFromAds < ActiveRecord::Migration[6.0]
  def change
    remove_column(:ads, :stale, :boolean)
  end
end

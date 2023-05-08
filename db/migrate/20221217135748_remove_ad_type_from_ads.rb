# frozen_string_literal: true

class RemoveAdTypeFromAds < ActiveRecord::Migration[7.0]
  def change
    remove_column(:ads, :ad_type, :string, null: false)
  end
end

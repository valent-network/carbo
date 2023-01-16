# frozen_string_literal: true
class AdjustReferencesToAndFromAds < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key(:ads, :cities)
    add_foreign_key(:ad_extras, :ads)
  end
end

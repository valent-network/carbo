# frozen_string_literal: true
class AddCityIdToAds < ActiveRecord::Migration[6.1]
  def change
    add_column(:ads, :city_id, 'smallint')
  end
end

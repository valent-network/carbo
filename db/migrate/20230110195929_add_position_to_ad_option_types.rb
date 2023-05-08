# frozen_string_literal: true

class AddPositionToAdOptionTypes < ActiveRecord::Migration[7.0]
  def change
    add_column(:ad_option_types, :position, :integer)
  end
end

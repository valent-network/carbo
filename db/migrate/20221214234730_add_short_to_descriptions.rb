# frozen_string_literal: true
class AddShortToDescriptions < ActiveRecord::Migration[7.0]
  def change
    add_column(:ad_descriptions, :short, :string, limit: 200)
  end
end

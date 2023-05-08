# frozen_string_literal: true

class AddNativeToAdsSources < ActiveRecord::Migration[7.0]
  def change
    add_column(:ads_sources, :native, :boolean, default: false)
  end
end

# frozen_string_literal: true
class CreateRegions < ActiveRecord::Migration[6.1]
  def change
    create_table(:regions) do |t|
      t.string(:name, null: false, limit: 255)
    end
  end
end

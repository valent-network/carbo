# frozen_string_literal: true
class CreateCities < ActiveRecord::Migration[6.1]
  def change
    create_table(:cities) do |t|
      t.string(:name, null: false, limit: 255)
      t.belongs_to(:region)
    end

    add_index(:cities, [:name, :region_id], unique: true)
  end
end

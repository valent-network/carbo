# frozen_string_literal: true

class CreateAdsSources < ActiveRecord::Migration[6.0]
  def change
    create_table(:ads_sources) do |t|
      t.string(:title, null: false)
      t.string(:api_token, null: false)

      t.timestamps
    end

    add_index(:ads_sources, :api_token, unique: true)
    add_index(:ads_sources, :title, unique: true)
  end
end

# frozen_string_literal: true

class CreateAdExtras < ActiveRecord::Migration[7.0]
  def change
    create_table(:ad_extras) do |t|
      t.jsonb(:details, default: {})
      t.belongs_to(:ad, null: false, index: {unique: true})
      t.timestamps
    end
  end
end

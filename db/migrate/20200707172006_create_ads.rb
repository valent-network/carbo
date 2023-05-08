# frozen_string_literal: true

class CreateAds < ActiveRecord::Migration[6.0]
  def change
    create_table(:ads) do |t|
      t.belongs_to(:phone_number, null: false)
      t.belongs_to(:ads_source, null: false)

      t.integer(:price, null: false)
      t.boolean(:deleted, null: false, default: false)
      t.boolean(:stale, null: false, default: false)
      t.jsonb(:details, null: false)
      t.string(:ad_type, null: false)
      t.string(:address, null: false)

      t.timestamps
    end

    add_index(:ads, %w[address ads_source_id], unique: true)
    add_index(:ads, %w[phone_number_id updated_at ads_source_id], where: "(deleted = false) AND (stale = false)")

    add_foreign_key(:ads, :phone_numbers, on_delete: :cascade)
    add_foreign_key(:ads, :ads_sources, on_delete: :cascade)
  end
end

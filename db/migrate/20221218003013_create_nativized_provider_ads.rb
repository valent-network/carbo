# frozen_string_literal: true

class CreateNativizedProviderAds < ActiveRecord::Migration[7.0]
  def change
    create_table(:nativized_provider_ads, id: false) do |t|
      t.string(:address, null: false, primary_key: true)
      t.index(:address, unique: true)
    end
  end
end

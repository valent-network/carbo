# frozen_string_literal: true

class CreateAdFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table(:ad_favorites) do |t|
      t.references(:ad, null: false, index: false)
      t.references(:user, null: false)
      t.timestamps
    end

    add_index(:ad_favorites, [:ad_id, :user_id], unique: true)
    add_foreign_key(:ad_favorites, :users, on_delete: :cascade)
    add_foreign_key(:ad_favorites, :ads, on_delete: :cascade)
  end
end

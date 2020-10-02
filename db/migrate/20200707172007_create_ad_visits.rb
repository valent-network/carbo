# frozen_string_literal: true
class CreateAdVisits < ActiveRecord::Migration[6.0]
  def change
    create_table :ad_visits do |t|
      t.belongs_to(:user, null: false)
      t.belongs_to(:ad, null: false, index: false)
    end

    add_index(:ad_visits, %w[ad_id user_id], unique: true)

    add_foreign_key(:ad_visits, :users, on_delete: :cascade)
    add_foreign_key(:ad_visits, :ads, on_delete: :cascade)
  end
end

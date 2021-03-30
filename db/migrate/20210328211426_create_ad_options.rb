# frozen_string_literal: true
class CreateAdOptions < ActiveRecord::Migration[6.1]
  def change
    create_table(:ad_options) do |t|
      t.belongs_to(:ad, null: false)
      t.belongs_to(:ad_option_type, null: false)
      t.belongs_to(:ad_option_value, null: false)
    end

    add_index(:ad_options, [:ad_option_type_id, :ad_id], unique: true)
  end
end

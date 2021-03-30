# frozen_string_literal: true
class CreateAdOptionTypes < ActiveRecord::Migration[6.1]
  def change
    create_table(:ad_option_types) do |t|
      t.string(:name, null: false)
    end

    add_index(:ad_option_types, :name, unique: true)
  end
end

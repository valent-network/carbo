# frozen_string_literal: true
class CreateAdOptionValues < ActiveRecord::Migration[6.1]
  def change
    create_table(:ad_option_values) do |t|
      t.string(:value, null: false)
    end

    add_index(:ad_option_values, :value, unique: true)
  end
end

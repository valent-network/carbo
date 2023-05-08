# frozen_string_literal: true

class ChangeUniqIndexOnAdOptionTypes < ActiveRecord::Migration[7.0]
  def change
    remove_index(:ad_option_types, :name)
    add_index(:ad_option_types, [:name, :category_id], unique: true)
  end
end

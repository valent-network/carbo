# frozen_string_literal: true
class ManageAdOptionsIndexes < ActiveRecord::Migration[6.1]
  def change
    remove_index(:ad_options, [:ad_option_type_id, :ad_id])
    remove_index(:ad_options, :ad_id)
    remove_index(:ad_options, :ad_option_type_id)
    remove_index(:ad_options, :ad_option_value_id)

    add_index(:ad_options, [:ad_id, :ad_option_type_id], unique: true)
  end
end

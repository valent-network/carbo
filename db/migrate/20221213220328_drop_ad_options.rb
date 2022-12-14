# frozen_string_literal: true
class DropAdOptions < ActiveRecord::Migration[7.0]
  def up
    drop_table(:ad_options)
  end

  def down
    create_table(:ad_options) do |t|
      t.belongs_to(:ad, null: false)
      t.belongs_to(:ad_option_type, null: false)
      t.belongs_to(:ad_option_value, null: false)
    end

    add_index(:ad_options, [:ad_option_type_id, :ad_id], unique: true)
    add_index(:ad_options, %i[ad_id ad_option_value_id ad_option_type_id], where: 'ad_option_type_id = ANY (ARRAY[4, 6, 7])', name: :index_ad_options_on_data1)
    add_index(:ad_options, %i[ad_option_value_id], where: 'ad_option_type_id = ANY (ARRAY[4, 6, 7])', name: :index_ad_options_on_data2)
    add_index(:ad_options, [:ad_id, :ad_option_value_id], where: 'ad_option_type_id IN (1, 2, 4, 6, 7, 9, 11)')
  end
end

# frozen_string_literal: true

class AddDataDependentIndexesToAdOptions < ActiveRecord::Migration[7.0]
  def change
    add_index(:ad_options, %i[ad_id ad_option_value_id ad_option_type_id], where: "ad_option_type_id = ANY (ARRAY[4, 6, 7])", name: :index_ad_options_on_data1)
    add_index(:ad_options, %i[ad_option_value_id], where: "ad_option_type_id = ANY (ARRAY[4, 6, 7])", name: :index_ad_options_on_data2)
  end
end

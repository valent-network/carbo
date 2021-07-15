# frozen_string_literal: true
class ManageIndexesForProviderActualization < ActiveRecord::Migration[6.1]
  def change
    add_index(:ads, :address, unique: true)
    remove_index(:ads, %i[address ads_source_id], unique: true)
    add_index(:ads, %i[phone_number_id updated_at], where: 'ads_source_id = 1')
  end
end

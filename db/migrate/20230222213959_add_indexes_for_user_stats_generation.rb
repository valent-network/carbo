# frozen_string_literal: true
class AddIndexesForUserStatsGeneration < ActiveRecord::Migration[7.0]
  def up
    execute('CREATE INDEX index_ads_on_phone_number_id_include_id_where_deleted_false ON ads(phone_number_id) INCLUDE(id) WHERE deleted = FALSE')
    execute('CREATE INDEX index_ads_on_id_and_city_id_where_deleted_false ON ads(id, city_id) WHERE deleted = FALSE')
  end

  def down
    remove_index(:ads, name: :index_ads_on_phone_number_id_include_id_where_deleted_false)
    remove_index(:ads, name: :index_ads_on_id_and_city_id_where_deleted_false)
  end
end

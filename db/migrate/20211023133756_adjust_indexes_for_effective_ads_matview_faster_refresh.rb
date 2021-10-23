# frozen_string_literal: true
class AdjustIndexesForEffectiveAdsMatviewFasterRefresh < ActiveRecord::Migration[6.1]
  def up
    remove_index(:ads, name: 'index_ads_on_phone_number_id_where_deleted_false_include_price')
    remove_index(:ads, name: 'index_ads_on_phone_number_id_and_updated_at')
    execute('CREATE INDEX index_ads_on_phone_number_id_where_deleted_false_include_price ON ads(phone_number_id, id) INCLUDE(price) WHERE deleted = FALSE')
  end

  def down
    remove_index(:ads, name: 'index_ads_on_phone_number_id_where_deleted_false_include_price')
    execute('CREATE INDEX index_ads_on_phone_number_id_where_deleted_false_include_price ON ads(phone_number_id) INCLUDE(price) WHERE deleted = FALSE')
    execute('CREATE INDEX index_ads_on_phone_number_id_and_updated_at ON ads(phone_number_id, updated_at) WHERE deleted = FALSE')
  end
end

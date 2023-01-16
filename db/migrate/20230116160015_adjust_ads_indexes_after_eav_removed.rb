# frozen_string_literal: true
class AdjustAdsIndexesAfterEavRemoved < ActiveRecord::Migration[7.0]
  def up
    remove_index(:ads, :category_id)
    remove_index(:ads, name: :index_ads_on_id_and_price)
    remove_index(:ads, name: :index_ads_on_phone_number_id_where_deleted_false_include_price)
    add_index(:ads, %i[phone_number_id category_id id price], name: :index_ads_on_feed_filters, where: 'deleted = FALSE')
  end

  def down
    add_index(:ads, :category_id)
    add_index(:ads, [:id, :price], order: { id: :desc }, where: 'deleted = FALSE', name: :index_ads_on_id_and_price)
    execute('CREATE INDEX index_ads_on_phone_number_id_where_deleted_false_include_price ON ads(phone_number_id) INCLUDE(price) WHERE deleted = FALSE')
    remove_index(:ads, name: :index_ads_on_feed_filters)
  end
end

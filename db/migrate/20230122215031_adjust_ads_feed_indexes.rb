# frozen_string_literal: true

class AdjustAdsFeedIndexes < ActiveRecord::Migration[7.0]
  def up
    execute("DROP INDEX index_ads_on_feed_filters")
    execute("CREATE INDEX index_ads_on_feed_filters ON ads(id DESC, phone_number_id, category_id, price) WHERE deleted = FALSE")
    execute("CREATE INDEX index_ads_on_hops ON ads(id DESC, phone_number_id) WHERE deleted = FALSE")
  end

  def down
    execute("DROP INDEX index_ads_on_feed_filters")
    execute("DROP INDEX index_ads_on_hops")
    execute("CREATE INDEX index_ads_on_feed_filters ON ads(phone_number_id, category_id, id, price) WHERE deleted = FALSE")
  end
end

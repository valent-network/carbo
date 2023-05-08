# frozen_string_literal: true

class RemoveClusterIndexFromAdDescriptionsAndEvents < ActiveRecord::Migration[7.0]
  def up
    execute("ALTER TABLE ad_descriptions SET WITHOUT CLUSTER")
    execute("ALTER TABLE ad_image_links_sets SET WITHOUT CLUSTER")
    execute("ALTER TABLE events SET WITHOUT CLUSTER")
  end

  def down
    execute("CLUSTER ad_descriptions USING index_ad_descriptions_on_ad_id")
    execute("CLUSTER ad_image_links_sets USING index_ad_image_links_sets_on_ad_id")
    execute("CLUSTER events USING index_events_on_user_id")
  end
end

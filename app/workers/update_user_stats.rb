# frozen_string_literal: true
class UpdateUserStats
  include Sidekiq::Worker

  sidekiq_options queue: 'system', retry: true, backtrace: false

  def perform
    tmp_index_name = "index_on_user_onown_ads_#{rand(1_000_000)}"
    conn = ActiveRecord::Base.connection
    queries = [
      "DROP MATERIALIZED VIEW IF EXISTS user_known_ads",
      CreateMatviewUserKnownAds.new.call,
      "CREATE INDEX #{tmp_index_name} ON user_known_ads(user_id)",
      UpdateUserStatTopRegions.new.call,
      "DROP MATERIALIZED VIEW IF EXISTS user_known_ads",
      UpdateUserStatPopularityPercentage.new.call,
      UpdateUserStatAdoptionPercentage.new.call,
      UpdateUserStatPotentialReach.new.call,
      UpdateUserStatActivityPercentage.new.call,
    ]

    User.transaction do
      queries.each { |q| conn.execute(q) }
    end
  end
end

# frozen_string_literal: true

class SnapshotUserVisibility
  include Sidekiq::Worker

  sidekiq_options queue: 'system', retry: true, backtrace: false

  def perform
    visible_ads_query = UserConnection.visible_ads_count.to_sql

    visible_ads_default_query = UserConnection.visible_ads_default_count.to_sql

    business_ads_query = UserConnection.business_ads_count.to_sql

    known_query = UserConnection.known_contacts_count.to_sql

    friends_query = UserContact.joins(phone_number: :user).group(:user_id).select('user_contacts.user_id, COUNT(*) AS count').to_sql

    users_query = User.select('users.id, COUNT(user_contacts.id) AS count')
      .joins("LEFT JOIN events ON events.user_id = users.id AND events.name = 'snapshot_user_visibility' AND events.created_at > (NOW() - INTERVAL '1 day')")
      .left_joins(:user_contacts)
      .where('events.id IS NULL')
      .group('users.id')
      .to_sql

    Event.connection.execute(<<~SQL)
      INSERT INTO user_visibilities(user_id, data, created_at)
      SELECT users.id AS user_id,
             jsonb_build_object(
               'default_hops', '#{UserFriendlyAdsQuery::DEFAULT_HOPS_COUNT}',
               'contacts_count', COALESCE(users.count, 0),
               'visible_ads_count', COALESCE(visible_ads.count, 0),
               'registered_friends_count', COALESCE(friends.count, 0),
               'visible_friends_count', COALESCE(known.count, 0),
               'visible_ads_count_for_default_hops', COALESCE(visible_ads_default.count, 0),
               'visible_business_ads_count', COALESCE(business_ads.count, 0)
             ) AS data,
             NOW()
      FROM (#{users_query}) AS users
      LEFT JOIN (#{visible_ads_query}) AS visible_ads ON users.id = visible_ads.user_id
      LEFT JOIN (#{visible_ads_default_query}) AS visible_ads_default ON users.id = visible_ads_default.user_id
      LEFT JOIN (#{business_ads_query}) AS business_ads ON users.id = business_ads.user_id
      LEFT JOIN (#{known_query}) AS known ON users.id = known.user_id
      LEFT JOIN (#{friends_query}) AS friends ON users.id = friends.user_id
    SQL
  end
end

# frozen_string_literal: true

class SnapshotUserVisibility
  BATCH_SIZE = 10

  include Sidekiq::Worker

  sidekiq_options queue: 'system', retry: true, backtrace: false

  def perform
    visible_ads = UserConnection
      .select('user_connections.user_id, COUNT(DISTINCT ads.id) AS visible_ads_count')
      .joins(:ads)
      .where(ads: { deleted: false })
      .group('user_connections.user_id')
      .map { |t| [t.user_id, t.visible_ads_count] }
      .to_h

    visible_ads_default = UserConnection
      .select('user_connections.user_id, COUNT(DISTINCT ads.id) AS visible_ads_count_default')
      .joins(:ads)
      .where(ads: { deleted: false }, user_connections: { hops_count: 0..UserFriendlyAdsQuery::DEFAULT_HOPS_COUNT })
      .group('user_connections.user_id')
      .map { |t| [t.user_id, t.visible_ads_count_default] }
      .to_h

    business_ads = UserConnection
      .select('user_connections.user_id, COUNT(DISTINCT ads.id) AS business_ads_count')
      .joins(:ads)
      .where(ads: { deleted: false })
      .where("ads.phone_number_id IN (#{PhoneNumber.business.select(:id).to_sql})")
      .group('user_connections.user_id')
      .map { |t| [t.user_id, t.business_ads_count] }
      .to_h

    known = UserConnection
      .select('user_connections.user_id, COUNT(DISTINCT "user_contacts"."phone_number_id") AS known_phone_numbers_count')
      .joins(:user_contacts)
      .group('user_connections.user_id')
      .map { |t| [t.user_id, t.known_phone_numbers_count] }
      .to_h

    friends = UserContact.joins(phone_number: :user).group(:user_id).count

    users = User.select('users.id, COUNT(user_contacts.id) AS user_contacts_count')
      .joins("LEFT JOIN events ON events.user_id = users.id AND events.name = 'snapshot_user_visibility' AND events.created_at > (NOW() - INTERVAL '1 day')")
      .left_joins(:user_contacts)
      .where('events.id IS NULL')
      .group('users.id')
      .map do |t|
        [
          t.id,
          {
            default_hops: UserFriendlyAdsQuery::DEFAULT_HOPS_COUNT,
            contacts_count: t.user_contacts_count.to_i,
            registered_friends_count: friends[t.id].to_i,
            visible_friends_count: known[t.id].to_i,
            visible_ads_count: visible_ads[t.id].to_i,
            visible_ads_count_for_default_hops: visible_ads_default[t.id].to_i,
            visible_business_ads_count: business_ads[t.id].to_i,
          }
        ]
      end
      .to_h

    users.each do |id, data|
      CreateEvent.call(:snapshot_user_visibility, user: id, data: data)
    end
  end
end

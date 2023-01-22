# frozen_string_literal: true
class UserFriendlyAdsQueryV2
  LIMIT = 20
  DEFAULT_HOPS_COUNT = ENV.fetch('DEFAULT_HOPS_COUNT', 3)

  def call(user:, offset: 0, limit: LIMIT, filters: {})
    user_contacts_matched_phone_numbers = user.user_contacts.where('user_contacts.name ILIKE ?', "%#{filters[:query]}%").pluck(:phone_number_id) if filters[:query].present?
    effective_ads = FilteredAds.new.call(filters: filters_from_aliases_groups(filters), should_search_query: user_contacts_matched_phone_numbers.blank?)

    hops_count = filters[:hops_count]&.first&.to_i

    blocked_users_ids = user.blocked_users_ids
    if blocked_users_ids.present?
      effective_ads = effective_ads.where('ads.phone_number_id NOT IN (SELECT phone_number_id FROM user_blocked_phone_numbers WHERE user_id = ?)', user.id)
    end

    if hops_count == 0 || filters[:contacts_mode] == 'directFriends'
      effective_ads = effective_ads.where(phone_number_id: user.user_contacts.select(:phone_number_id))
    elsif user_contacts_matched_phone_numbers.present?
      known_numbers_filtered = KnownNumbersFiltered.new.call(user.id, filtered_friends_phone_number_ids: user_contacts_matched_phone_numbers)
      effective_ads = effective_ads.where("ads.phone_number_id IN (#{known_numbers_filtered})")
    else
      effective_ads = effective_ads
        .joins(%[JOIN user_contacts ON user_contacts.phone_number_id = ads.phone_number_id])
        .joins(%[JOIN user_connections ON user_contacts.user_id = user_connections.connection_id AND "user_connections"."user_id" = #{user.id} AND (user_connections.hops_count <= #{hops_count || DEFAULT_HOPS_COUNT})])
    end

    query = effective_ads.offset(offset)
    query = query.order('ads.id DESC')
    query = query.limit(limit) if limit > 0

    query
  end

  private

  def filters_from_aliases_groups(filters)
    extra = CachedSettings.new.filterable_values_groups
      .select { |opt, _| opt.to_s.in?(filters.keys.map(&:to_s)) }
      .map do |opt, fvgs|
        [
          opt,
          fvgs.select { |fvg_id, _| fvg_id.to_s.in?(filters[opt].map(&:to_s)) }.values.flatten
        ]
      end
      .to_h

    {
      'min_price' => filters[:min_price],
      'max_price' => filters[:max_price],
      'query' => filters[:query],
      'category_id' => filters[:category_id],
      'extra' => extra,
    }
  end
end

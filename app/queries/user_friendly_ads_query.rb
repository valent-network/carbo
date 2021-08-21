# frozen_string_literal: true
class UserFriendlyAdsQuery
  LIMIT = 20

  def call(user:, offset: 0, limit: LIMIT, filters: {})
    user_contacts_matched_phone_numbers = user.user_contacts.where('user_contacts.name ILIKE ?', "%#{filters[:query]}%").pluck(:phone_number_id) if filters[:query].present?
    effective_ads = EffectiveAds.new.call(filters: filters, should_search_query: user_contacts_matched_phone_numbers.blank?)

    if filters[:contacts_mode] == 'directFriends'
      ads = effective_ads.where("ads.phone_number_id IN (SELECT phone_number_id FROM user_contacts WHERE user_id = #{user.id})")
    elsif user_contacts_matched_phone_numbers.present?
      known_numbers = KnownNumbersFiltered.new.call(user.id, filtered_friends_phone_number_ids: user_contacts_matched_phone_numbers)
      ads = effective_ads.where("ads.phone_number_id IN (#{known_numbers})")
    else
      ads = effective_ads.joins("JOIN user_contacts ON ads.phone_number_id = user_contacts.phone_number_id")
      ads = ads.joins("JOIN user_connections ON user_connections.user_id = #{user.id} AND user_contacts.user_id = user_connections.connection_id")
    end

    query = ads.offset(offset)
    query = query.order('ads.id DESC')
    query = query.limit(limit) if limit > 0

    Ad.where(id: query.select(:id).distinct(:id).map(&:id)).order('ads.created_at DESC')
  end
end

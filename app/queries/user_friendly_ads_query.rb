# frozen_string_literal: true
class UserFriendlyAdsQuery
  MAX_HANDS_COUNT = 7
  LIMIT = 20

  def call(user:, offset: 0, limit: LIMIT, filters: {})
    user_contacts_matched_phone_numbers = user.user_contacts.where('user_contacts.name ILIKE ?', "%#{filters[:query]}%").pluck(:phone_number_id) if filters[:query].present?

    max_hands_count = filters[:contacts_mode] == 'directFriends' ? 1 : MAX_HANDS_COUNT
    friends_phones = UserFriendsPhoneNumbersQuery.new.call(user.id, max_hands_count: max_hands_count, filtered_friends_phone_number_ids: user_contacts_matched_phone_numbers)
    ads = Ad.where("ads.phone_number_id IN (#{friends_phones})").active

    ads = ads.where('price >= ?', filters[:min_price]) if filters[:min_price].present?
    ads = ads.where('price <= ?', filters[:max_price]) if filters[:max_price].present?

    ads = ads.where("details->>'year' >= ?", filters[:min_year]) if filters[:min_year].present?
    ads = ads.where("details->>'year' <= ?", filters[:max_year]) if filters[:max_year].present?

    ads = ads.where("details->>'fuel' IN (?)", filters[:fuels]) if filters[:fuels].present?
    ads = ads.where("details->>'gear' IN (?)", filters[:gears]) if filters[:gears].present?
    ads = ads.where("details->>'wheels' IN (?)", filters[:wheels]) if filters[:wheels].present?
    ads = ads.where("details->>'carcass' IN (?)", filters[:carcasses]) if filters[:carcasses].present?

    if filters[:query].present?
      unless user_contacts_matched_phone_numbers.present?
        ads = ads.where("CONCAT(details->>'maker', ' ',details->>'model') ILIKE :q OR details->>'model' ILIKE :q", q: "#{filters[:query].strip}%")
      end
    end

    query = ads.offset(offset).order(created_at: :desc)
    query = query.limit(limit) if limit > 0
    query
  end
end

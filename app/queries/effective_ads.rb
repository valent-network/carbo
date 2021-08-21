# frozen_string_literal: true
class EffectiveAds
  def call(filters:, should_search_query:)
    ads = Ad.from('effective_ads AS ads')

    ads = ads.where('price >= ?', filters[:min_price].to_i) if filters[:min_price].present?
    ads = ads.where('price <= ?', filters[:max_price].to_i) if filters[:max_price].present?
    ads = ads.where("year >= ?", filters[:min_year].to_i) if filters[:min_year].present?
    ads = ads.where("year <= ?", filters[:max_year].to_i) if filters[:max_year].present?

    ads = ads.where("fuel IN (?)", filters[:fuels]) if filters[:fuels].present?
    ads = ads.where("gear IN (?)", filters[:gears]) if filters[:gears].present?
    ads = ads.where("wheels IN (?)", filters[:wheels]) if filters[:wheels].present?
    ads = ads.where("carcass IN (?)", filters[:carcasses]) if filters[:carcasses].present?

    if filters[:query].present? && should_search_query
      ads = ads.where('search_query ILIKE ?', "%#{filters[:query].strip}%")
    end

    ads
  end
end

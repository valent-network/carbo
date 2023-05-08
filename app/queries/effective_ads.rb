# frozen_string_literal: true

class EffectiveAds
  FILTERS_COLUMNS_MAPPING = {
    fuels: :fuel,
    gears: :gear,
    wheels: :wheels,
    carcasses: :carcass
  }
  def call(filters:, should_search_query:)
    ads = Ad.active.distinct(:id)

    ads = ads.where("price >= ?", filters[:min_price].to_i) if filters[:min_price].present?
    ads = ads.where("price <= ?", filters[:max_price].to_i) if filters[:max_price].present?

    if %i[fuels gears wheels carcasses min_year max_year].any? { |t| filters[t].present? }
      ads = ads.joins(:ad_extra)
    end

    if %i[min_year max_year].any? { |t| filters[t].present? }
      min_year = filters[:min_year].to_i.in?(1950..2023) ? filters[:min_year].to_i : 1950
      max_year = filters[:max_year].to_i.in?(1950..2023) ? filters[:max_year].to_i : 2023

      years_clause = (min_year..max_year).map do |year|
        %[(ad_extras.details @> '{"year": #{year}}')]
      end.join(" OR\n")

      ads = ads.where(years_clause)
    end

    %i[fuels gears wheels carcasses].select { |t| filters[t].present? }.each do |opt_type|
      filter_clause = Array.wrap(filters[opt_type]).map do |opt_val|
        %[(ad_extras.details @> '{"#{FILTERS_COLUMNS_MAPPING[opt_type]}": "#{opt_val}"}')]
      end.join(" OR\n")

      ads = ads.where(filter_clause)
    end

    if filters[:query].present? && should_search_query
      ads = ads.joins(:ad_query).where("ad_queries.title ILIKE ?", "%#{filters[:query].strip}%")
    end

    ads
  end
end

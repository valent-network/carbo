# frozen_string_literal: true
class EffectiveAds
  def call(filters:, should_search_query:)
    ads = Ad.from('effective_ads AS ads').group('ads.id, ads.phone_number_id')
    ads = ads.select('DISTINCT ON (ads.id) ads.id, ads.phone_number_id')
    ads = ads.where('price >= ?', filters[:min_price]) if filters[:min_price].present?
    ads = ads.where('price <= ?', filters[:max_price]) if filters[:max_price].present?

    option_types_ids = all_option_types_ids
    option_values_ids = option_values_ids_for(filters)

    if filters[:min_year].present? || filters[:max_year].present?
      year_option_value_ids = option_value_ids_for_year_range(filters[:min_year], filters[:max_year])
      ads = ads.by_options('year', option_types_ids['year'], year_option_value_ids)
    end

    ads = ads.by_options('fuel', option_types_ids['fuel'], option_values_ids[:fuels]) if filters[:fuels].present?
    ads = ads.by_options('gear', option_types_ids['gear'], option_values_ids[:gears]) if filters[:gears].present?
    ads = ads.by_options('wheels', option_types_ids['wheels'], option_values_ids[:wheels]) if filters[:wheels].present?
    ads = ads.by_options('carcass', option_types_ids['carcass'], option_values_ids[:carcasses]) if filters[:carcasses].present?

    if filters[:query].present? && should_search_query
      query_ids = AdOptionType.where(name: %w[maker model year]).pluck(:id).join(', ')

      ads = ads.joins(:ad_options)
      ads = ads.joins("JOIN ad_option_types on ad_option_types.id = ad_options.ad_option_type_id and ad_option_types.id IN (#{query_ids})")
      ads = ads.joins('JOIN ad_option_values on ad_option_values.id = ad_options.ad_option_value_id')
      ads = ads.having("array_to_string(array_agg(ad_option_values.value ORDER BY ad_option_types.name ASC), ' ') ILIKE ?", "%#{filters[:query].strip}%")
    end

    ads.to_sql
  end

  private

  def all_option_types_ids
    names = %w[fuel gear wheels carcass year]

    Hash[AdOptionType.where(name: names).pluck(:name, :id)]
  end

  def option_values_ids_for(filters)
    accepted_filters = filters.slice(:fuels, :gears, :wheels, :carcasses)
    values = accepted_filters.select { |_k, v| v.present? }.values.flatten

    ids = Hash[AdOptionValue.where(value: values).pluck(:value, :id)]

    accepted_filters.transform_values { |value| value.map { |v| ids[v] }.flatten }
  end

  def option_value_ids_for_year_range(min_year, max_year)
    years_range = (min_year.presence || 1950).to_i..(max_year.presence || Time.now.year).to_i
    AdOptionValue.where(value: years_range).pluck(:id)
  end
end

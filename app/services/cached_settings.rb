# frozen_string_literal: true
class CachedSettings
  SETTINGS = %i[filters filterable_values_groups cities categories]

  attr_reader :locale, :json

  def initialize(locale = I18n.locale.to_s)
    @locale = locale
    @json = REDIS.get("settings.#{locale}") || '{}'
  end

  SETTINGS.each do |setting|
    define_method(setting) do
      JSON.parse(json)[setting.to_s]
    end
  end

  class << self
    def refresh
      I18n.available_locales.each do |locale|
        REDIS.set("settings.#{locale}", I18n.with_locale(locale) { _settings.to_json })
      end
    end

    def clear
      I18n.available_locales.each do |locale|
        REDIS.set("settings.#{locale}", nil)
      end
    end

    private

    def _settings
      {
        filters: _filters,
        cities: _cities,
        categories: _categories,
        filterable_values_groups: _filterable_values_groups,
      }
    end

    def _filters
      FilterableValue
        .includes(:ad_option_type)
        .joins(:ad_option_type)
        .where(ad_option_types: { filterable: true })
        .map { |fv| [fv.ad_option_type.name, [fv.name, fv.raw_value]] }
        .group_by(&:first)
        .transform_values do |v|
          v.map(&:last).group_by(&:first).transform_values { |group| group.map(&:last) }
        end
    end

    def _cities
      cities_grouped_by_region = City.includes(:region).where("translations->>'uk' IS NOT NULL AND translations->>'en' IS NOT NULL").group_by(&:region)
      regions_sorted = AlphabetSort.call(cities_grouped_by_region.keys.map { |x| x.translations[I18n.locale.to_s] }, I18n.locale)
      cities_sorted = AlphabetSort.call(cities_grouped_by_region.values.flatten.map { |city| city.translations[I18n.locale.to_s] }, I18n.locale)

      cities_grouped_by_region
        .sort_by { |k, _v| regions_sorted.index(k.translations[I18n.locale.to_s]) }
        .to_h
        .transform_keys { |region| region.translations[I18n.locale.to_s] }
        .transform_values do |cities|
          cities.sort_by { |city| cities_sorted.index(city.translations[I18n.locale.to_s]) }.map { |city| { name: city.translations[I18n.locale.to_s], id: city.id } }
        end
    end

    def _categories
      categories = Category.includes(ad_option_types: [filterable_values: [ad_option_type: :groups]]).all
      sorted_categories = AlphabetSort.call(categories.map { |c| c.translations[I18n.locale.to_s] }, I18n.locale)
      categories.sort_by { |c| sorted_categories.index(c.translations[I18n.locale.to_s]) }.map do |c|
        {
          name: c.translations[I18n.locale.to_s],
          currency: c.currency,
          id: c.id,
          position: c.try(:position),
          ad_option_types: c.ad_option_types.map do |opt|
            values = opt.filterable_values.select { |fv| fv.group.present? }.map do |f|
              {
                name: f.group.translations[I18n.locale.to_s],
                id: f.group.id,
                position: f.group.position,
              }
            end.uniq { |x| x[:id] }

            {
              localized_name: opt.translations[I18n.locale.to_s],
              name: opt.name,
              input_type: opt.input_type,
              id: opt.id,
              filterable: opt.filterable,
              values: opt.filterable ? values : [],
              position: opt.position,
            }
          end,
        }
      end
    end

    def _filterable_values_groups
      FilterableValuesGroup
        .joins(:ad_option_type)
        .includes(:ad_option_type, :values)
        .where(ad_option_types: { filterable: true })
        .all
        .group_by { |fvg| fvg.ad_option_type.name }
        .transform_values do |fvgs|
          fvgs.map do |fvg|
            [
              fvg.id,
              fvg.values.select { |fv| fv.ad_option_type_id == fvg.ad_option_type_id }.map(&:raw_value)
            ]
          end.to_h
        end
    end
  end
end

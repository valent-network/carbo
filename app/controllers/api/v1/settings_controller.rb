# frozen_string_literal: true
module Api
  module V1
    class SettingsController < ApplicationController
      def show
        payload = {
          filters: { hops_count: t('hops_count').map.with_index.to_a.map { |h| { name: h.first, id: h.last } } },
          cities: cities,
          categories: categories,
        }

        render(json: payload)
      end

      private

      def cities # TODO: get from redis
        cities_grouped_by_region = City.includes(:region).group_by(&:region)
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

      def categories # TODO: get from redis
        categories = Category.includes(ad_option_types: [filterable_values: [ad_option_type: :groups]]).all
        sorted_categories = AlphabetSort.call(categories.map { |c| c.translations[I18n.locale.to_s] }, I18n.locale)
        categories.sort_by { |c| sorted_categories.index(c.translations[I18n.locale.to_s]) }.map do |c|
          {
            name: c.translations[I18n.locale.to_s],
            currency: c.currency,
            id: c.id,
            ad_option_types: c.ad_option_types.map do |opt|
              values = opt.filterable_values.select { |fv| fv.group.present? }.map do |f|
                {
                  name: f.group.translations[I18n.locale.to_s],
                  id: f.group.id,
                }
              end.uniq { |x| x[:id] }

              {
                localized_name: I18n.t("ad_options.#{opt.name}"),
                name: opt.name,
                input_type: opt.input_type,
                id: opt.id,
                filterable: opt.filterable,
                values: opt.filterable ? values : [],
              }
            end,
          }
        end
      end
    end
  end
end

# frozen_string_literal: true
module Api
  module V2
    class AdSerializer < ActiveModel::Serializer
      attributes :id, :deleted, :price, :options, :translated_options, :image, :images, :title, :description, :url, :prices, :friend_name_and_total, :short_description, :my_ad, :city_id, :category_id, :region

      def options
        case object.category.name
        when 'vehicles'
          AdCarOptionsPresenter.new.call(object.details)
        else
          details_translations.map do |k, v|
            t = AdOptionType.find_by_name(k)
            translated_key = t ? t.translations[I18n.locale.to_s] : k

            [k, [translated_key, v]]
          end.to_h
        end
      end

      def translated_options
        object.ad_extra_details.to_h.map { |k, v| [k, details_translations[k] || v] }.to_h
      end

      def description
        object.details['description'].presence || I18n.t('ad_options.no_description')
      end

      def short_description
        object.ad_description_short
      end

      def prices
        AdPricesPresenter.new.call(object)
      end

      def price
        ActiveSupport::NumberHelper.number_to_delimited(object.price, delimiter: ' ')
      end

      def image
        images.first
      end

      def images
        images = object.details['images_json_array_tmp']
        images.is_a?(String) ? JSON.parse(images) : Array.wrap(images)
      end

      def url
        object.address unless object.ads_source.native?
      end

      def region
        object.region.translations[I18n.locale.to_s] if object.region
      end

      private

      def details_translations
        return @details_translations if @details_translations

        groups = object.ad_extra_details.to_a

        all_fv = FilterableValue.all.includes(ad_option_type: :groups).to_a # TODO: get from redis
        filters = CachedSettings.new.filters

        details_translations = groups.reject { |g| g.last.blank? }.map do |g|
          option_type, raw_value = g
          value_group = filters[option_type]&.detect { |group| group.last.map(&:to_s).map(&:downcase).include?(raw_value.to_s.downcase) }&.first

          if value_group
            fvg = all_fv.detect { |fv| fv.name == value_group }
            translation_or_fallback = fvg&.group ? fvg.group.translations[I18n.locale.to_s] : value_group

            [option_type, translation_or_fallback]
          else
            [option_type, nil]
          end
        end

        @details_translations = details_translations.to_h
      end
    end
  end
end

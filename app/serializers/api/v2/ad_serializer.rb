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
          # TODO: N+1
          FilterableValue.raw_value_to_translation_for_groups_v2(object.ad_extra_details.to_a).map do |k, v|
            t = AdOptionType.find_by_name(k)
            translated_key = t ? t.translations[I18n.locale.to_s] : k

            [k, [translated_key, v]]
          end.to_h
        end
      end

      def translated_options
        details = object.ad_extra_details
        translations = FilterableValue.raw_value_to_translation_for_groups_v2(details.to_a).to_h
        details.to_h.map { |k, v| [k, translations.to_h[k] || v] }.to_h
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
    end
  end
end

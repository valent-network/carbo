# frozen_string_literal: true
module Api
  module V2
    class AdSerializer < ActiveModel::Serializer
      attributes :id,
        :deleted,
        :price,
        :options,
        :translated_options,
        :image,
        :images,
        :ad_images,
        :title,
        :description,
        :url,
        :prices,
        :friend_name_and_total,
        :short_description,
        :my_ad,
        :city_id,
        :category_id,
        :region,
        :category_currency,
        :native,
        :updated_at,
        :stats

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
        native_image = object.ad_images.sort_by(&:position).first

        if native_image
          { id: native_image.id, url: native_image.attachment_url(:feed), position: native_image.position }
        else
          external_image = tmp_images.first

          external_image ? { url: external_image[:url], position: external_image[:position] } : {}
        end
      end

      def images
        object.ad_images.sort_by(&:position).map { |ai| { id: ai.id, url: ai.attachment_url(:feed), position: ai.position } }.presence || tmp_images
      end

      def ad_images
        images
      end

      def tmp_images
        t = object.details['images_json_array_tmp']
        t = t.is_a?(String) ? JSON.parse(t) : Array.wrap(t)
        t.map.with_index.to_a.map { |h| { url: h.first, position: h.last } }
      end

      def url
        object.address unless object.ads_source.native?
      end

      def native
        object.ads_source.native?
      end

      def region
        object.region.translations[I18n.locale.to_s] if object.region
      end

      def stats
        object.my_ad ? object.stats : {}
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

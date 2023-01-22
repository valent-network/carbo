# frozen_string_literal: true

module Api
  module V1
    class AdsListSerializer < ActiveModel::Serializer
      attributes :id, :image, :title, :price, :short_description, :friend_name_and_total, :city, :region, :my_ad, :deleted

      def price
        ActiveSupport::NumberHelper.number_to_delimited(object.price, delimiter: ' ')
      end

      def short_description
        object.ad_description_short
      end

      def city
        I18n.t('ad_options.city_value', value: object.city_display_name)
      end

      def region
        object.region_display_name
      end

      def image
        native_image = object.ad_images.sort_by(&:position).first

        if native_image
          { id: native_image.id, url: native_image.attachment_url, position: native_image.position }
        else
          external_image = tmp_images.first

          external_image ? { url: external_image[:url], position: external_image[:position] } : {}
        end
      end

      def tmp_images
        t = object.details['images_json_array_tmp']
        t = t.is_a?(String) ? JSON.parse(t) : Array.wrap(t)
        t.map.with_index.to_a.map { |h| { url: h.first, position: h.last } }
      end
    end
  end
end

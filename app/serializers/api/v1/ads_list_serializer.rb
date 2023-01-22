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
          native_image.attachment_url(:feed)
        else
          tmp_images.first
        end
      end

      def tmp_images
        t = object.details['images_json_array_tmp']
        t.is_a?(String) ? JSON.parse(t) : Array.wrap(t)
      end
    end
  end
end

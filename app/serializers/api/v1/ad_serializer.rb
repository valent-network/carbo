# frozen_string_literal: true
module Api
  module V1
    class AdSerializer < ActiveModel::Serializer
      attributes :id, :deleted, :price, :options, :image, :images, :title, :description, :url, :prices, :friend_name_and_total, :short_description

      def options
        AdCarOptionsPresenter.new.call(object.details)
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
    end
  end
end

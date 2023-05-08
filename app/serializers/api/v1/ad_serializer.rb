# frozen_string_literal: true

module Api
  module V1
    class AdSerializer < ActiveModel::Serializer
      attributes :id, :deleted, :price, :options, :image, :images, :title, :description, :url, :prices, :friend_name_and_total, :short_description

      def options
        AdCarOptionsPresenter.new.call(object.details)
      end

      def description
        object.details["description"].presence || I18n.t("ad_options.no_description")
      end

      def short_description
        object.ad_description_short
      end

      def prices
        AdPricesPresenter.new.call(object)
      end

      def price
        ActiveSupport::NumberHelper.number_to_delimited(object.price, delimiter: " ")
      end

      def image
        native_image = object.ad_images.sort_by(&:position).first

        native_image ? native_image.attachment_url(:feed) : tmp_images.first
      end

      def images
        object.ad_images.sort_by(&:position).map { |ai| ai.attachment_url(:feed) }.presence || tmp_images
      end

      def url
        object.address unless object.ads_source.native?
      end

      private

      def tmp_images
        t = object.details["images_json_array_tmp"]
        t.is_a?(String) ? JSON.parse(t) : Array.wrap(t)
      end
    end
  end
end

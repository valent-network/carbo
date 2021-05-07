# frozen_string_literal: true
module Api
  module V1
    class AdSerializer < ActiveModel::Serializer
      attributes :id, :deleted, :price, :options, :image, :images, :title, :description, :short_description, :url, :prices, :friend_name_and_total

      def options
        AdCarOptionsPresenter.new.call(object.new_details)
      end

      def description
        object.new_details['description'].presence || I18n.t('ad_options.no_description')
      end

      def prices
        AdPricesPresenter.new.call(object)
      end

      def price
        ActiveSupport::NumberHelper.number_to_delimited(object.price, delimiter: ' ')
      end

      def title
        "#{object.new_details['maker']} #{object.new_details['model']} #{object.new_details['year']}"
      end

      def image
        images.first
      end

      def images
        images = object.new_details['images_json_array_tmp']
        images.is_a?(String) ? JSON.parse(images) : Array.wrap(images)
      end

      def short_description
        AdCarShortDescriptionPresenter.new.call(object.new_details)
      end

      def url
        object.address
      end
    end
  end
end

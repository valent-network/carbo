# frozen_string_literal: true
module Api
  module V1
    class AdSerializer < ActiveModel::Serializer
      attributes :id, :deleted, :price, :options, :images, :title, :description, :url, :prices

      def options
        AdCarOptionsPresenter.new.call(object.details)
      end

      def description
        object.details['description'].presence || I18n.t('ad_options.no_description')
      end

      def prices
        AdPricesPresenter.new.call(object)
      end

      def price
        ActiveSupport::NumberHelper.number_to_delimited(object.price, delimiter: ' ')
      end

      def title
        "#{object.details['maker']} #{object.details['model']} #{object.details['year']}"
      end

      def images
        images = object.details['images_json_array_tmp']
        images.is_a?(String) ? JSON.parse(images) : images
      end

      def url
        object.address
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class AdsListSerializer < ActiveModel::Serializer
      attributes :id, :image, :title, :price, :short_description, :friend_name_and_total

      def image
        images = object.details['images_json_array_tmp']
        images.is_a?(String) ? JSON.parse(images).first : images.first
      end

      def title
        "#{object.details['maker']} #{object.details['model']} #{object.details['year']}"
      end

      def price
        ActiveSupport::NumberHelper.number_to_delimited(object.price, delimiter: ' ')
      end

      def short_description
        AdCarShortDescriptionPresenter.new.call(object.details)
      end
    end
  end
end

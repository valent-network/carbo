# frozen_string_literal: true

module Api
  module V1
    class AdsListSerializer < ActiveModel::Serializer
      attributes :id, :image, :title, :price, :short_description, :friend_name_and_total

      def image
        images = object.new_details['images_json_array_tmp']
        images.is_a?(String) ? JSON.parse(images).first : Array.wrap(images).first
      end

      def title
        "#{object.new_details['maker']} #{object.new_details['model']} #{object.new_details['year']}"
      end

      def price
        ActiveSupport::NumberHelper.number_to_delimited(object.price, delimiter: ' ')
      end

      def short_description
        AdCarShortDescriptionPresenter.new.call(object.new_details)
      end
    end
  end
end

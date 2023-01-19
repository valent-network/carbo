# frozen_string_literal: true

module Api
  module V1
    class AdsListSerializer < ActiveModel::Serializer
      attributes :id, :image, :title, :price, :short_description, :friend_name_and_total, :city, :region, :my_ad, :deleted, :category_currency, :favorite

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

      def favorite
        return unless @instance_options[:current_user]

        object.ad_favorites.detect { |af| af.user_id == @instance_options[:current_user].id }.present?
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class FeedAdsController < ApplicationController
      before_action :require_auth

      def index
        ads = UserFriendlyAdsQuery.new.call(user: current_user, offset: params[:offset], filters: filter_params)
        ads = Ad.where(id: ads.ids).includes(:ad_description, :ad_image_links_set, ad_options: [:ad_option_type, :ad_option_value], city: [:region])
        ads_phone_number_ids = ads.map(&:phone_number_id)

        if ads_phone_number_ids.present?
          ads_with_friends_sql = AdsWithFriendsQuery.new.call(current_user, ads_phone_number_ids)
          ads_with_friends = Ad.find_by_sql(ads_with_friends_sql)

          ads.each { |ad| ad.associate_friends_with(ads_with_friends) }
        end

        render(json: ads, each_serializer: Api::V1::AdsListSerializer)
      end

      private

      def filter_params
        return {} unless params[:filters]

        params[:filters].permit(:contacts_mode, :min_price, :max_price, :min_year, :max_year, :query, gears: [], wheels: [], carcasses: [], fuels: [])
      end
    end
  end
end

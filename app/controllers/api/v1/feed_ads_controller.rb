# frozen_string_literal: true

module Api
  module V1
    class FeedAdsController < ApplicationController
      FILTERS = [
        :contacts_mode,
        :min_price,
        :max_price,
        :min_year,
        :max_year,
        :query,
        {
          hops_count: [],
          gears: [],
          wheels: [],
          carcasses: [],
          fuels: [],
        }
      ]

      before_action :require_auth

      def index
        ads = UserFriendlyAdsQuery.new.call(user: current_user, offset: params[:offset], filters: filter_params)
        ads = Ad.where(id: ads.ids).eager_load(:ad_description, :ad_extra, :ad_query, :ad_image_links_set, :city, :region).order('ads.id DESC')
        ads_phone_number_ids = ads.map(&:phone_number_id)

        if ads_phone_number_ids.present?
          ads_with_friends_sql = AdsWithFriendsQuery.new.call(current_user, ads_phone_number_ids)
          ads_with_friends = Ad.find_by_sql(ads_with_friends_sql)

          ads.each { |ad| current_user.phone_number_id == ad.phone_number_id ? ad.my_add! : ad.associate_friends_with(ads_with_friends) }
        end

        CreateEvent.call(:get_feed, user: current_user, data: { params: params })

        render(json: ads, each_serializer: Api::V1::AdsListSerializer)
      end

      private

      def filter_params
        return {} unless params[:filters]

        params[:filters].permit(*FILTERS)
      end
    end
  end
end
